defmodule InteractiveTetris.RoomTest do
  use InteractiveTetris.ModelCase

  alias InteractiveTetris.Room

  @valid_attrs %{active: true, name: "Room 1", score: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
