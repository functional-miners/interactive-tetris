defmodule InteractiveTetris.Room do
  use InteractiveTetris.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "rooms" do
    field :name, :string
    field :score, :integer, default: 0
    field :active, :boolean, default: false
    field :finished, :boolean, default: false
    belongs_to :author, InteractiveTetris.User

    timestamps
  end

  @required_fields ~w(name score active finished)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
  end
end
