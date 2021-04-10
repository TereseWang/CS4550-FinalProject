defmodule Cat.Repo.Migrations.CreateForumcomment do
  use Ecto.Migration

  def change do
    create table(:forumcomment) do
      add :body, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :forum_id, references(:forums, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:forumcomment, [:user_id])
    create index(:forumcomment, [:forum_id])
  end
end
