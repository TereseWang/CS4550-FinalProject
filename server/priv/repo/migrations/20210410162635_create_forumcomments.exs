defmodule Cat.Repo.Migrations.CreateForumcomments do
  use Ecto.Migration

  def change do
    create table(:forumcomments) do
      add :body, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :forum_id, references(:forums, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:forumcomments, [:user_id])
    create index(:forumcomments, [:forum_id])
  end
end
