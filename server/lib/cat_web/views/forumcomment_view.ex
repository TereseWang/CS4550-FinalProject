defmodule CatWeb.ForumcommentView do
  use CatWeb, :view
  alias CatWeb.ForumcommentView
  alias CatWeb.UserView

  def render("index.json", %{forumcomment: forumcomment}) do
    %{data: render_many(forumcomment, ForumcommentView, "forumcomment.json")}
  end

  def render("show.json", %{forumcomment: forumcomment}) do
    %{data: render_one(forumcomment, ForumcommentView, "forumcomment.json")}
  end

  def render("forumcomment.json", %{forumcomment: forumcomment}) do
    user = if Ecto.assoc_loaded?(forumcomment.user) do
      render_one(forumcomment.user, UserView, "user.json")
    else
      nil
    end
    %{id: forumcomment.id,
      body: forumcomment.body,
      user_id: forumcomment.user_id,
      forum_id: forumcomment.health_id,
      user: user}
  end
end
