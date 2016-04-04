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

    :ets.new(:interactive_tetris_active_games, [:set, :public, :named_table])

    opts = [strategy: :one_for_one, name: InteractiveTetris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    InteractiveTetris.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_game(room_id, socket) do
    game = InteractiveTetris.GameSupervisor.start_game(room_id)
    :ets.insert_new(:interactive_tetris_active_games, {room_id, game})

    game
  end

  def start_pusher(socket, game) do
    InteractiveTetris.StatePusherSupervisor.start_pusher(socket, game)
  end

  def get_game_by_room_id(room_id) do
    case :ets.lookup(:interactive_tetris_active_games, room_id) do
      [ {_, pid} ] -> pid
      []           -> nil
    end
  end
end
