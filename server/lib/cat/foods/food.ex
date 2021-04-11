defmodule Cat.Foods.Food do
  use Ecto.Schema
  import Ecto.Changeset

  schema "foods" do
    field :type, :string
    field :body, :string
    field :brand, :string
    field :photo_hash, :string
    field :price, :integer
    field :like, {:array, :integer}
    field :dislike, {:array, :integer}
    belongs_to :user, Cat.Users.User

    timestamps()
  end

  @doc false
  def changeset(food, attrs) do
    food
    |> cast(attrs, [:brand, :price, :photo_hash, :type, :body, :user_id, :like, :dislike])
    |> validate_required([:brand, :price, :photo_hash, :type, :body, :user_id,  :like, :dislike])
  end
end
