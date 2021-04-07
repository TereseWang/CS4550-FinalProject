defmodule Cat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :reason, :string
    field :photo_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :reason, :photo_hash])
    |> validate_required([:name, :email, :password_hash, :reason, :photo_hash])
  end
end
