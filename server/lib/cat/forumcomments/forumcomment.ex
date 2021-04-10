defmodule Cat.Forumcomments.Forumcomment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forumcomments" do
    field :body, :string
    belongs_to :user, Cat.Users.User
    belongs_to :forum, Cat.Forums.Forum

    timestamps()
  end

  @doc false
  def changeset(forumcomment, attrs) do
    forumcomment
    |> cast(attrs, [:body, :forum_id, :user_id])
    |> validate_required([:body, :forum_id, :user_id])
  end
end
