defmodule InteractiveTetris.Game.StateTest do
  use ExUnit.Case, async: true

  alias InteractiveTetris.Game.State

  test "cell_at/2" do
    board = [[0, 1, 2],
             [3, 4, 5],
             [6, 7, 8]]
    state = %State{board: board}

    assert State.cell_at(state, {0, 0}) == 0
    assert State.cell_at(state, {1, 0}) == 1
    assert State.cell_at(state, {2, 0}) == 2
    assert State.cell_at(state, {0, 1}) == 3
    assert State.cell_at(state, {1, 1}) == 4
    assert State.cell_at(state, {2, 1}) == 5
    assert State.cell_at(state, {0, 2}) == 6
    assert State.cell_at(state, {1, 2}) == 7
    assert State.cell_at(state, {2, 2}) == 8
  end

  test "cells_for_shape" do
    state = %State{current: :oh, rotation: 0, x: 1, y: 1}
    cells = State.cells_for_shape(state)
    assert MapSet.new(cells) == MapSet.new([{1, 1}, {2, 1}, {1, 2}, {2, 2}])

    state = %State{state | current: :ell, rotation: 2}
    cells = State.cells_for_shape(state)
    assert MapSet.new(cells) == MapSet.new([{1, 1}, {2, 1}, {2, 2}, {2, 3}])

    state = %State{state | x: 3, y: 4}
    cells = State.cells_for_shape(state)
    assert MapSet.new(cells) == MapSet.new([{3, 4}, {4, 4}, {4, 5}, {4, 6}])
  end
end
