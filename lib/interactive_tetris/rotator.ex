defmodule InteractiveTetris.Rotator do
  import Enum, only: [at: 2, count: 1]

  def rotate(piece, 0) do
    piece
  end

  def rotate(piece, angle) do
    # ...
  end

  def rotate(_, _) do
    raise ArgumentError, "Amount must be divisible by 90"
  end

  defp width(piece),  do: count(piece)
  defp height(piece), do: count(hd(piece))
end
