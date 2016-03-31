defmodule InteractiveTetris.Repo.Migrations.CreateConnectedGames do
  use Ecto.Migration

  def change do
    create table(:connected_games, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :delete_all, type: :binary_id)
    end

    create index(:connected_games, [:user_id])
    create index(:connected_games, [:room_id])
  end
end
