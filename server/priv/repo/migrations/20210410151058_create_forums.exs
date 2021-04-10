defmodule Cat.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums) do
      add :user_id, references(:users), null: false
      add :body, :text, null: false
      add :photo_hash, :text, null: false
      add :title, :string, null: false
      add :votes, {:array, :integer}, default: []
      timestamps()
    end

  end
end
