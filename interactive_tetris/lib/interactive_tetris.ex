defmodule InteractiveTetris do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(InteractiveTetris.Endpoint, []),
      supervisor(InteractiveTetris.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: InteractiveTetris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    InteractiveTetris.Endpoint.config_change(changed, removed)
    :ok
  end
end
