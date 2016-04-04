defmodule InteractiveTetris.StatePusher do
  use GenServer

  @render_interval 100

  def start_link(socket, game) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {socket, game})
    :timer.send_interval(@render_interval, pid, :tick)
    {:ok, pid}
  end

  def init(input) do
    {:ok, input}
  end

  # TODO: Pushing also other users moves to the clients.

  def handle_info(:tick, {socket, game} = state) do
    Phoenix.Channel.push socket, "game:state", InteractiveTetris.Game.get_state(game)
    {:noreply, state}
  end
end
