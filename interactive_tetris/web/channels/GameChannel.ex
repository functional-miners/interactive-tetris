defmodule InteractiveTetris.GameChannel do
  use Phoenix.Channel

  def join("tetris", %{ "roomId" => room_id }, socket) do
    send(self, :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in("event", %{"event" => event_name}, socket) do
    pid = InteractiveTetris.get_game_by_room_id(socket.assigns.room_id)
    InteractiveTetris.Game.handle_input(pid, String.to_atom(event_name))

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    game = case InteractiveTetris.get_game_by_room_id(socket.assigns.room_id) do
      nil    -> InteractiveTetris.start_game(socket.assigns.room_id, socket)
      result -> result
    end

    InteractiveTetris.start_pusher(socket, game)

    {:noreply, socket}
  end
end
