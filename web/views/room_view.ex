defmodule InteractiveTetris.RoomView do
  use InteractiveTetris.Web, :view

  alias InteractiveTetris.Room
  alias InteractiveTetris.User

  def active_room(%Room{ :active => true, :finished => false }), do: "active-row"
  def active_room(%Room{ :active => false, :finished => false }), do: "ready-row"
  def active_room(_), do: "inactive-row"

  def is_current_user_an_author(conn, %Room{ :author => %User{ :username => username } }) do
    username == Plug.Conn.get_session(conn, :username)
  end
end
