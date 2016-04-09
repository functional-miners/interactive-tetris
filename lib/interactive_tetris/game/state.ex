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
    shape = Shapes.get(state.current, state.rotation)
    for {row, row_i} <- Enum.with_index(shape) do
      for {col, col_i} <- Enum.with_index(row), col != 0 do
        {col_i + state.x, row_i + state.y}
      end
    end |> List.flatten
  end

  def cell_at(state, {x, y}) do
    state.board
    |> Enum.at(y)
    |> Enum.at(x)
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
    {board, points} = clear_lines(state.board, [], [])
    %__MODULE__{state | board: board, points: state.points + points}
  end
  defp clear_lines([line|rest], accum, cleared) do
    case clearable?(line) do
      true  -> clear_lines(rest, accum, cleared ++ [line])
      false -> clear_lines(rest, accum ++ [line], cleared)
    end
  end
  defp clear_lines([], accum, cleared) do
    empty_lines = for line <- cleared, do: Helpers.empty_line(length(line))
    {empty_lines ++ accum, length(cleared)}
  end

  defp collidable?(line) do
    line
    |> Enum.any?(fn(x) -> x != 0 end)
  end

  defp clearable?(line) do
    line
    |> Enum.all?(fn(x) -> x != 0 end)
  end
end
