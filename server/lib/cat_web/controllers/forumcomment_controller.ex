defmodule CatWeb.ForumcommentController do
  use CatWeb, :controller

  alias Cat.Forumcomments
  alias Cat.Forumcomments.Forumcomment

  action_fallback CatWeb.FallbackController

  def index(conn, _params) do
    forumcomment = Forumcomments.list_forumcomment()
    render(conn, "index.json", forumcomment: forumcomment)
  end

  def create(conn, %{"forumcomment" => forumcomment_params}) do
    with {:ok, %Forumcomment{} = forumcomment} <- Forumcomments.create_forumcomment(forumcomment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.forumcomment_path(conn, :show, forumcomment))
      |> render("show.json", forumcomment: forumcomment)
    end
  end

  def show(conn, %{"id" => id}) do
    forumcomment = Forumcomments.get_forumcomment!(id)
    render(conn, "show.json", forumcomment: forumcomment)
  end

  def update(conn, %{"id" => id, "forumcomment" => forumcomment_params}) do
    forumcomment = Forumcomments.get_forumcomment!(id)

    with {:ok, %Forumcomment{} = forumcomment} <- Forumcomments.update_forumcomment(forumcomment, forumcomment_params) do
      render(conn, "show.json", forumcomment: forumcomment)
    end
  end

  def delete(conn, %{"id" => id}) do
    forumcomment = Forumcomments.get_forumcomment!(id)

    with {:ok, %Forumcomment{}} <- Forumcomments.delete_forumcomment(forumcomment) do
      send_resp(conn, :no_content, "")
    end
  end
end
