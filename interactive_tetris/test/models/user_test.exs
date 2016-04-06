defmodule InteractiveTetris.UserTest do
  use InteractiveTetris.ModelCase

  alias InteractiveTetris.User

  @valid_attrs %{username: "jerry"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
