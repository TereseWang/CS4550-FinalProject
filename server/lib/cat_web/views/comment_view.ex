defmodule CatWeb.CommentView do
  use CatWeb, :view
  alias CatWeb.CommentView
  alias CatWeb.UserView
  alias CatWeb.HealthView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    user = if Ecto.assoc_loaded?(comment.user) do
      render_one(comment.user, UserView, "user.json")
    else
      nil
    end
    health = if Ecto.assoc_loaded?(comment.health) do
      render_one(comment.health, HealthView, "health.json")
    else
      nil
    end
    %{id: comment.id,
      body: comment.body,
      user_id: comment.user_id,
      health_id: comment.health_id,
      user: user,
      health: health}
  end
end
