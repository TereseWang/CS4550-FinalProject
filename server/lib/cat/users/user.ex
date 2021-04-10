defmodule Cat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :reason, :string
    field :photo_hash, :string
    has_many :healths, Cat.Healths.Health
    has_many :comments, Cat.Comments.Comment
    has_many :forums, Cat.Forums.Forum
    has_many :forumcomments, Cat.Forumcomments.Forumcomment
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :email, :photo_hash, :password_hash,
      :reason])
      |> add_password_hash(attrs["password"])
      |> unique_constraint(:email)
      |> validate_required([:name, :email, :photo_hash, :password_hash,
      :reason])
  end

  def add_password_hash(cset, nil) do
    cset
  end

  def add_password_hash(cset, password) do
    change(cset, Argon2.add_hash(password))
  end
end
