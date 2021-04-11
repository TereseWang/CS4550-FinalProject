defmodule CatWeb.HealthController do
  use CatWeb, :controller

  alias Cat.Healths
  alias Cat.Healths.Health
  alias Cat.Photos

  action_fallback CatWeb.FallbackController

  def index(conn, _params) do
    healths = Healths.list_healths()
    render(conn, "index.json", healths: healths)
  end

#referenced from Nat Lecture, Photo_Blog Post controller
  def update_photo(health_params) do
    if health_params["photo"] != "undefined" do
      {:ok, photo_hash} = Photos.save_photo(
      health_params["photo"].filename,
      health_params["photo"].path
      )
      health_params = health_params
      |> Map.put("photo_hash", photo_hash)
      health_params
    else
      photos = Application.app_dir(:cat, "priv/photos")
      path = Path.join(photos, "default.jpg")
      {:ok, photo_hash} = Photos.save_photo("default.jpg", path)
      health_params = health_params
      |> Map.put("photo_hash", photo_hash)
      |> Map.put("photo", "default")
      health_params
    end
  end

  def validate_params(health_params) do
    Map.values(health_params) |> Enum.member?("") || Map.values(health_params) |> Enum.member?("undefined")
  end


  def create(conn, %{"health" => health_params}) do
    health_params = update_photo(health_params)
    vote_list = Jason.decode!(health_params["votes"])
    health_params = health_params
    |> Map.put("votes", vote_list)
    if !validate_params(health_params) do
      with {:ok, %Health{} = health} <- Healths.create_health(health_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.health_path(conn, :show, health))
        |> render("show.json", health: health)
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
    health = Healths.get_health!(id)
    render(conn, "show.json", health: health)
  end

  def update(conn, %{"id" => id, "health" => health_params}) do
    health = Healths.get_health!(id)
    vote_list =
      if health_params["votes"] do
        Jason.decode!(health_params["votes"])
      else
        vote_list = health.votes
      end
    h_params = Map.put(health_params, "votes", vote_list)

    if h_params["photo"] != "undefined" do
      if !validate_params(h_params) do
        {:ok, photo_hash} = Photos.save_photo(
        h_params["photo"].filename,
        h_params["photo"].path
        )
        h_params = h_params
        |> Map.put("photo_hash", photo_hash)
        with {:ok, %Health{} = health} <- Healths.update_health(health, h_params) do
          conn
          |> render("show.json", health: health)
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
      h_params = Map.put(h_params, "photo", health.photo_hash)
      if !validate_params(h_params) do
        with {:ok, %Health{} = health} <- Healths.update_health(health, h_params) do
          conn
          |> render("show.json", health: health)
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
    health = Healths.get_health!(id)
    IO.inspect(health)
    with {:ok, %Health{}} <- Healths.delete_health(health) do
      send_resp(conn, :no_content, "")
    end
  end
end
