defmodule InteractiveTetris.PageController do
  use InteractiveTetris.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
