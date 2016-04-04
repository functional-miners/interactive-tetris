defmodule InteractiveTetris.GameSupervisor do
  use Supervisor

  def start_game(_room_id) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    pid
  end

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(InteractiveTetris.Game, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
