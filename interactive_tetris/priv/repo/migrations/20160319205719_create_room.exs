defmodule InteractiveTetris.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :score, :integer, default: 0
      add :active, :boolean, default: false
      add :author_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps
    end
    create index(:rooms, [:author_id])

  end
end
