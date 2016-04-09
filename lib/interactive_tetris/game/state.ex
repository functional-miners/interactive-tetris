defmodule InteractiveTetris.Game.State do
  defmodule Helpers do
    def empty_line(length \\ 18) do
      1..length
      |> Enum.map(fn(_) -> 0 end)
    end
  end

  alias InteractiveTetris.Shapes

  defstruct [:board, :next, :current, :rotation, :x, :y, :points, :room, :active]

  def cells_for_shape(state) do
    shape = # ...
    # get_cells
  end

  def cell_at(state, point) do
    x = # ...
    y = # ...
    # ...
  end

  def still_playable?(state) do
    playable_lines(state.board, 0) < 22
  end

  defp playable_lines([line | rest], counter) do
    case collidable?(line) do
      true  -> playable_lines(rest, counter + 1)
      false -> playable_lines(rest, counter)
    end
  end
  defp playable_lines([], counter) do
    counter
  end

  def clear_lines(state) do
    new_board = # ...
    new_points = # ...
    %__MODULE__{state | board: new_board, points: new_points}
  end

  defp collidable?(line) do
    line
    |> Enum.any?(fn(x) -> x != 0 end)
  end
end
