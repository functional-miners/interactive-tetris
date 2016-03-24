defmodule InteractiveTetris.LayoutView do
  use InteractiveTetris.Web, :view

  def logged(conn) do
    Plug.Conn.get_session(conn, :username) != nil
  end
end
