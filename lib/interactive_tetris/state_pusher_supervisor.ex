defmodule InteractiveTetris.StatePusherSupervisor do
  use Supervisor

  def start_pusher(socket, game) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [socket, game])
    pid
  end

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(InteractiveTetris.StatePusher, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
