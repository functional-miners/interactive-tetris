defmodule InteractiveTetris.ConnectedGame do
  use InteractiveTetris.Web, :model

  @primary_key false
  @foreign_key_type :binary_id

  schema "connected_games" do
    belongs_to :room, InteractiveTetris.Room
    belongs_to :user, InteractiveTetris.User
  end

  def changeset(model, _params \\ :empty) do
    model
  end
end
