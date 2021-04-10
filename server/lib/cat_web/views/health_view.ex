defmodule CatWeb.HealthView do
  use CatWeb, :view
  alias CatWeb.HealthView
  alias CatWeb.UserView

  def render("index.json", %{healths: healths}) do
    %{data: render_many(healths, HealthView, "health.json")}
  end

  def render("show.json", %{health: health}) do
    %{data: render_one(health, HealthView, "health.json")}
  end

  def render("health.json", %{health: health}) do
    %{
      id: health.id,
      user_id: health.user_id,
      body: health.body,
      photo_hash: health.photo_hash,
      votes: health.votes,
      title: health.title}
  end
end
