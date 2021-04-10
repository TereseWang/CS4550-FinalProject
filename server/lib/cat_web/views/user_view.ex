defmodule CatWeb.UserView do
  use CatWeb, :view
  alias CatWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      reason: user.reason,
      photo_hash: user.photo_hash,
      password_hash: user.password_hash,
      reason: user.reason}
  end
end
