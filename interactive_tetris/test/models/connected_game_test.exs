defmodule InteractiveTetris.ConnectedGameTest do
  use InteractiveTetris.ModelCase

  alias InteractiveTetris.ConnectedGame

  @valid_attrs %{}

  test "changeset with valid attributes should directly return model" do
    model = ConnectedGame.changeset(%ConnectedGame{}, @valid_attrs)
    assert model.__struct__ == ConnectedGame
  end
end
