defmodule Cat.Healths.Health do
  use Ecto.Schema
  import Ecto.Changeset

  schema "healths" do
    field :body, :string
    field :photo_hash, :string
    field :title, :string
    field :votes, {:array, :integer}
    belongs_to :user, Cat.Users.User
    has_many :comments, Cat.Comments.Comment, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(health, attrs) do
    health
    |> cast(attrs, [:body, :user_id, :photo_hash, :title, :votes])
    |> validate_required([:body, :user_id, :photo_hash, :title, :votes])
  end
end
