defmodule Cat.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :health, Cat.Healths.Health
    belongs_to :user, Cat.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :health_id, :user_id])
    |> validate_required([:body, :health_id, :user_id])
  end
end
