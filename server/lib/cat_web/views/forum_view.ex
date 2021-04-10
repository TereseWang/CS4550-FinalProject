defmodule CatWeb.ForumView do
  use CatWeb, :view
  alias CatWeb.ForumView
  alias CatWeb.UserView

  def render("index.json", %{forums: forums}) do
    %{data: render_many(forums, ForumView, "forum.json")}
  end

  def render("show.json", %{forum: forum}) do
    %{data: render_one(forum, ForumView, "forum.json")}
  end

  def render("forum.json", %{forum: forum}) do
    %{
      id: forum.id,
      user_id: forum.user_id,
      body: forum.body,
      photo_hash: forum.photo_hash,
      votes: forum.votes,
      title: forum.title}
  end
end
