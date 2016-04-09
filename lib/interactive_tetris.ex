defmodule InteractiveTetris do
  use Application

  alias InteractiveTetris.Repo
  alias InteractiveTetris.Room

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(InteractiveTetris.Endpoint, []),
      supervisor(InteractiveTetris.Repo, []),
      supervisor(InteractiveTetris.GameSupervisor, []),
      supervisor(InteractiveTetris.StatePusherSupervisor, [])
    ]

    :ets.new(:interactive_tetris_active_games, [:set, :public, :named_table])
    :ets.new(:interactive_tetris_active_pushers, [:set, :public, :named_table])

    opts = [strategy: :one_for_one, name: InteractiveTetris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    InteractiveTetris.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_game(room_id) do
    game = InteractiveTetris.GameSupervisor.start_game(room_id)
    :ets.insert_new(:interactive_tetris_active_games, {room_id, game})

    game
  end

  def start_pusher(socket, room_id, game) do
    pusher = InteractiveTetris.StatePusherSupervisor.start_pusher(socket, game)
    :ets.insert_new(:interactive_tetris_active_pushers, {room_id, pusher})

    pusher
  end

  def get_game_by_room_id(room_id) do
    case :ets.lookup(:interactive_tetris_active_games, room_id) do
      [ {_, pid} ] -> pid
      []           -> nil
    end
  end

  def get_pusher_by_room_id(room_id) do
    case :ets.lookup(:interactive_tetris_active_pushers, room_id) do
      [ {_, pid} ] -> pid
      []           -> nil
    end
  end

  def clean_up(room_id) do
    pusher = get_pusher_by_room_id(room_id)
    GenServer.call(pusher, :stop)

    game = get_game_by_room_id(room_id)
    state = GenServer.call(game, :stop)

    room = Repo.get(Room, room_id)
    changeset = Room.changeset(room, %{ :score => state.points })

    Repo.update(changeset)

    :ets.delete(:interactive_tetris_active_games, room_id)
    :ets.delete(:interactive_tetris_active_pushers, room_id)
  end
end
