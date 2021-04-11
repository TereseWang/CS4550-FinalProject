defmodule CatWeb.FoodController do
  use CatWeb, :controller

  alias Cat.Foods
  alias Cat.Foods.Food
  alias Cat.Photos

  action_fallback CatWeb.FallbackController

  def index(conn, _params) do
    foods = Foods.list_foods()
    render(conn, "index.json", foods: foods)
  end

#referenced from Nat Lecture, Photo_Blog Post controller
  def update_photo(food_params) do
    if food_params["photo"] != "undefined" do
      {:ok, photo_hash} = Photos.save_photo(
      food_params["photo"].filename,
      food_params["photo"].path
      )
      food_params = food_params
      |> Map.put("photo_hash", photo_hash)
      food_params
    else
      photos = Application.app_dir(:cat, "priv/photos")
      path = Path.join(photos, "default.jpg")
      {:ok, photo_hash} = Photos.save_photo("default.jpg", path)
      food_params = food_params
      |> Map.put("photo_hash", photo_hash)
      |> Map.put("photo", "default")
      food_params
    end
  end

  def validate_params(food_params) do
    Map.values(food_params) |> Enum.member?("") || Map.values(food_params) |> Enum.member?("undefined")
  end

#referenced from Nat Lecture, Photo_Blog Post controller
  def create(conn, %{"food" => food_params}) do
    like_list = Jason.decode!(food_params["like"])
    food_params = food_params
    |> Map.put("like", like_list)

    dislike_list = Jason.decode!(food_params["dislike"])
    food_params = food_params
    |> Map.put("dislike", dislike_list)

    food_params = update_photo(food_params)
    IO.inspect(food_params)
    if !validate_params(food_params) do
      with {:ok, %Food{} = food} <- Foods.create_food(food_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.food_path(conn, :show, food))
        |> render("show.json", food: food)
      end
    else
      conn
      |> put_resp_header(
      "content-type",
      "application/json; charset=UTF-8")
      |> send_resp(
      :unauthorized,
      Jason.encode!(%{error: "Fields Missing"})
      )
    end
  end

  def show(conn, %{"id" => id}) do
    food = Foods.get_food!(id)
    render(conn, "show.json", food: food)
  end

#referenced from Nat Lecture, Photo_Blog Post controller
  def update(conn, %{"id" => id, "food" => food_params}) do
    food = Foods.get_food!(id)
    like_list =
      if food_params["like"] do
        Jason.decode!(food_params["like"])
      else
        vote_list = food.votes
      end
    dislike_list =
      if food_params["dislike"] do
        Jason.decode!(food_params["dislike"])
      else
        vote_list = food.votes
      end
    h_params = food_params
    |>Map.put("like", like_list)
    |>Map.put("dislike", dislike_list)
    IO.inspect(h_params)
    if h_params["photo"] != "undefined" do
      if !validate_params(h_params) do
        {:ok, photo_hash} = Photos.save_photo(
        h_params["photo"].filename,
        h_params["photo"].path
        )
        h_params = h_params
        |> Map.put("photo_hash", photo_hash)
        with {:ok, %Food{} = food} <- Foods.update_food(food, h_params) do
          conn
          |> render("show.json", food: food)
        end
      else
        conn
        |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
        |> send_resp(
        :unauthorized,
        Jason.encode!(%{error: "Fields Missing"})
        )
      end
    else
      h_params = Map.put(h_params, "photo", food.photo_hash)
      if !validate_params(h_params) do
        with {:ok, %Food{} = food} <- Foods.update_food(food, h_params) do
          conn
          |> render("show.json", food: food)
        end
      else
        conn
        |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
        |> send_resp(
        :unauthorized,
        Jason.encode!(%{error: "Fields Missing"})
        )
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    food = Foods.get_food!(id)

    with {:ok, %Food{}} <- Foods.delete_food(food) do
      send_resp(conn, :no_content, "")
    end
  end
end
