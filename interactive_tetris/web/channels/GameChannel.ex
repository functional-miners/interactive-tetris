defmodule InteractiveTetris.GameChannel do
  use Phoenix.Channel

  def join("tetris", %{ "roomId" => room_id, "user" => username }, socket) do
    send(self, :after_join)
    {:ok, assign(assign(socket, :room_id, room_id), :username, username)}
  end

  def handle_in("event", %{"event" => event_name}, socket) do
    pid = InteractiveTetris.get_game_by_room_id(socket.assigns.room_id)
    InteractiveTetris.Game.handle_input(pid, String.to_atom(event_name))

    Phoenix.Channel.broadcast socket, "game:movement", %{ "event" => event_name, "user" => socket.assigns.username }

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    game = case InteractiveTetris.get_game_by_room_id(socket.assigns.room_id) do
             nil ->
               InteractiveTetris.start_game(socket.assigns.room_id)

             result ->
               InteractiveTetris.GameSupervisor.update_game(socket.assigns.room_id)
               result
           end

    InteractiveTetris.start_pusher(socket, game)

    {:noreply, socket}
  end
end
