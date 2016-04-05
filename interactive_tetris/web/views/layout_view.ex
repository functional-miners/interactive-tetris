defmodule InteractiveTetris.LayoutView do
  use InteractiveTetris.Web, :view

  def logged(conn) do
    Plug.Conn.get_session(conn, :username) != nil
  end

  def get_username(conn) do
    Plug.Conn.get_session(conn, :username)
  end
end
