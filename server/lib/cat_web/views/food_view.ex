defmodule CatWeb.FoodView do
  use CatWeb, :view
  alias CatWeb.FoodView
  alias CatWeb.UserView

  def render("index.json", %{foods: foods}) do
    %{data: render_many(foods, FoodView, "food.json")}
  end

  def render("show.json", %{food: food}) do
    %{data: render_one(food, FoodView, "food.json")}
  end

  def render("food.json", %{food: food}) do
    user = if Ecto.assoc_loaded?(food.user) do
      render_one(food.user, UserView, "user.json")
    else
      nil
    end
    %{
      user_id: food.user_id,
      user: user,
      id: food.id,
      brand: food.brand,
      price: food.price,
      photo_hash: food.photo_hash,
      type: food.type,
      body: food.body,
      like: food.like,
      dislike: food.dislike}
  end
end
