defmodule InteractiveTetris do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(InteractiveTetris.Endpoint, []),
      supervisor(InteractiveTetris.Repo, []),
      supervisor(InteractiveTetris.GameSupervisor, []),
      supervisor(InteractiveTetris.StatePusherSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: InteractiveTetris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    InteractiveTetris.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_game(room_id, socket) do
    game = InteractiveTetris.GameSupervisor.start_game(room_id)
    InteractiveTetris.StatePusherSupervisor.start_pusher(socket, game)
  end
end
