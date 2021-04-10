defmodule CatWeb.UserController do
  use CatWeb, :controller

  alias Cat.Users
  alias Cat.Users.User
  alias Cat.Photos

  action_fallback CatWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def update_photo(user_params) do
    if user_params["photo"] != "undefined" do
      {:ok, photo_hash} = Photos.save_photo(
        user_params["photo"].filename,
        user_params["photo"].path
      )
      user_params = user_params
      |> Map.put("photo_hash", photo_hash)
      user_params
    else
      photos = Application.app_dir(:cat, "priv/photos")
      path = Path.join(photos, "default.jpg")
      {:ok, photo_hash} = Photos.save_photo("default.jpg", path)
      user_params = user_params
      |> Map.put("photo_hash", photo_hash)
      |> Map.put("photo", "default")
      user_params
    end
  end

  def create(conn, %{"user" => user_params}) do
    try do
      user_params = update_photo(user_params)
      if !validate_params(user_params) do
        if Users.get_user_by_email!(user_params["email"]) == nil do
          with {:ok, %User{} = user} <- Users.create_user(user_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.user_path(conn, :show, user))
            |> render("show.json", user: user)
          end
        else
          conn
          |> put_resp_header(
          "content-type",
          "application/json; charset=UTF-8")
          |> send_resp(
          :unauthorized,
          Jason.encode!(%{error: "User With This Email Already Exist"})
          )
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
  rescue
    _e in MultipleResultsError ->
    conn
    |> put_resp_header(
      "content-type",
      "application/json; charset=UTF-8")
    |> send_resp(
    :unauthorized,
    Jason.encode!(%{error: "This User has Already Been Exist"})
    )
  end
  end

  def validate_params(user_params) do
    Map.values(user_params) |> Enum.member?("") || Map.values(user_params) |> Enum.member?("undefined")
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  #reference from Nat Tuck Lecture Notes photo function
  #in photo_blog/lib/photo_blog_web/controller/post_controller.ex
  def photo(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _name, data} = Photos.load_photo(user.photo_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    if user_params["photo"] != "undefined" do
      if !validate_params(user_params) do
        {:ok, photo_hash} = Photos.save_photo(
        user_params["photo"].filename,
        user_params["photo"].path
        )
        user_params = user_params
        |> Map.put("photo_hash", photo_hash)
        with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
          conn
          |> render("show.json", user: user)
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
      user_params = Map.put(user_params, "photo", user.photo_hash)
      if !validate_params(user_params) do
        with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
          conn
          |> render("show.json", user: user)
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
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
