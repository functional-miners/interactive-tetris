defmodule InteractiveTetris.GameChannel do
  use Phoenix.Channel

  def join("tetris", %{ "roomId" => room_id }, socket) do
    send(self, :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in("event", %{"event" => _event_name}, socket) do
    # TODO: 1. Get PID by room_id from ETS.
    # TODO: InteractiveTetris.Game.handle_input(pid, String.to_atom(event_name))

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    InteractiveTetris.start_game(socket.assigns.room_id, socket)
    {:noreply, socket}
  end
end
