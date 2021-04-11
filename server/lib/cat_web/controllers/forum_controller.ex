defmodule CatWeb.ForumController do
  use CatWeb, :controller

  alias Cat.Forums
  alias Cat.Forums.Forum
  alias Cat.Photos

  action_fallback CatWeb.FallbackController

  def index(conn, _params) do
    forums = Forums.list_forums()
    render(conn, "index.json", forums: forums)
  end

#referenced from Nat Lecture, Photo_Blog Post controller
  def update_photo(forum_params) do
    if forum_params["photo"] != "undefined" do
      {:ok, photo_hash} = Photos.save_photo(
      forum_params["photo"].filename,
      forum_params["photo"].path
      )
      forum_params = forum_params
      |> Map.put("photo_hash", photo_hash)
      forum_params
    else
      photos = Application.app_dir(:cat, "priv/photos")
      path = Path.join(photos, "default.jpg")
      {:ok, photo_hash} = Photos.save_photo("default.jpg", path)
      forum_params = forum_params
      |> Map.put("photo_hash", photo_hash)
      |> Map.put("photo", "default")
      forum_params
    end
  end

  def validate_params(forum_params) do
    Map.values(forum_params) |> Enum.member?("") || Map.values(forum_params) |> Enum.member?("undefined")
  end

  def create(conn, %{"forum" => forum_params}) do
    forum_params = update_photo(forum_params)
    vote_list = Jason.decode!(forum_params["votes"])
    forum_params = forum_params
    |> Map.put("votes", vote_list)
    if !validate_params(forum_params) do
      with {:ok, %Forum{} = forum} <- Forums.create_forum(forum_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.forum_path(conn, :show, forum))
        |> render("show.json", forum: forum)
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
    forum = Forums.get_forum!(id)
    render(conn, "show.json", forum: forum)
  end

  def update(conn, %{"id" => id, "forum" => forum_params}) do
    forum = Forums.get_forum!(id)
    vote_list =
      if forum_params["votes"] do
        Jason.decode!(forum_params["votes"])
      else
        vote_list = forum.votes
      end
    h_params = Map.put(forum_params, "votes", vote_list)

    if h_params["photo"] != "undefined" do
      if !validate_params(h_params) do
        {:ok, photo_hash} = Photos.save_photo(
        h_params["photo"].filename,
        h_params["photo"].path
        )
        h_params = h_params
        |> Map.put("photo_hash", photo_hash)
        with {:ok, %Forum{} = forum} <- Forums.update_forum(forum, h_params) do
          conn
          |> render("show.json", forum: forum)
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
      h_params = Map.put(h_params, "photo", forum.photo_hash)
      if !validate_params(h_params) do
        with {:ok, %Forum{} = forum} <- Forums.update_forum(forum, h_params) do
          conn
          |> render("show.json", forum: forum)
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
    forum = Forums.get_forum!(id)
    IO.inspect(forum)
    with {:ok, %Forum{}} <- Forums.delete_forum(forum) do
      send_resp(conn, :no_content, "")
    end
  end
end
