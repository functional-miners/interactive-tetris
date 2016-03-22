defmodule InteractiveTetris.PageController do
  use InteractiveTetris.Web, :controller

  def game(conn, _params) do
    render(conn, "game.html")
  end

  def summary(conn, _params) do
    render(conn, "summary.html")
  end
end
