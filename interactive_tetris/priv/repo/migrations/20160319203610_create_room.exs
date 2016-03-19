defmodule InteractiveTetris.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :score, :integer
      add :active, :boolean, default: false
      add :author, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:rooms, [:author])

  end
end
