defmodule InteractiveTetris.RoomView do
  use InteractiveTetris.Web, :view

  alias InteractiveTetris.Room

  def active_room(%Room{ :active => true, :finished => false }), do: "active-row"
  def active_room(%Room{ :active => false, :finished => false }), do: "ready-row"
  def active_room(_), do: "inactive-row"
end
