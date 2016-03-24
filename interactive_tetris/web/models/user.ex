defmodule InteractiveTetris.User do
  use InteractiveTetris.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :username, :string
    has_many :connected_games, InteractiveTetris.ConnectedGame

    timestamps
  end

  @required_fields ~w(username)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username)
  end
end
