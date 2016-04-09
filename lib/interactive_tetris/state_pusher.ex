defmodule InteractiveTetris.StatePusher do
  use GenServer

  @render_interval 100

  def start_link(socket, game) do
    GenServer.start_link(__MODULE__, {socket, game})
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def init(input) do
    :timer.send_interval(@render_interval, self(), :tick)

    {:ok, input}
  end

  def handle_info(:tick, {socket, game} = state) do
    Phoenix.Channel.push socket, "game:state", InteractiveTetris.Game.get_state(game)
    {:noreply, state}
  end
end
