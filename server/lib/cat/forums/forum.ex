defmodule Cat.Forums.Forum do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forums" do
    field :body, :string
    field :photo_hash, :string
    field :title, :string
    field :votes, {:array, :integer}
    belongs_to :user, Cat.Users.User
    has_many :forumcomments, Cat.Forumcomments.Forumcomment 
    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, [:body, :title, :photo_hash, :votes, :user_id])
    |> validate_required([:body, :title, :photo_hash, :votes, :user_id])
  end
end
