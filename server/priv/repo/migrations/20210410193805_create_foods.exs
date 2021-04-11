defmodule Cat.Repo.Migrations.CreateFoods do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :user_id, references(:users), null: false
      add :brand, :string, null: false
      add :price, :integer, null: false
      add :photo_hash, :string, null: false
      add :type, :string, null: false
      add :body, :text, null: false
      add :like, {:array, :integer}, default: []
      add :dislike, {:array, :integer}, default: []
      timestamps()
    end
  end
end
