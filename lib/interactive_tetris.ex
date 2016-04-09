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
    :ets.insert_new(:interactive_tetris_active_games, {game, room_id})

    game
  end

  def start_pusher(socket, room_id, game) do
    pusher = InteractiveTetris.StatePusherSupervisor.start_pusher(socket, game)
    :ets.insert_new(:interactive_tetris_active_pushers, {pusher, room_id})

    pusher
  end

  def get_game_by_room_id(room_id) do
    IO.inspect("GET GAME #{inspect :ets.match(:interactive_tetris_active_games, {:"$1", room_id})}")
    case :ets.match(:interactive_tetris_active_games, {:"$1", room_id}) do
      [ [ pid ] ] -> pid
      []          -> nil
    end
  end

  def get_pushers_by_room_id(room_id) do
    IO.inspect("GET PUSHERS #{inspect :ets.match(:interactive_tetris_active_pushers, {:"$1", room_id})}")
    :ets.match(:interactive_tetris_active_pushers, {:"$1", room_id})
    |> Enum.map(fn([ pid ]) -> pid end)
  end

  def clean_up(room_id) do
    pushers = get_pushers_by_room_id(room_id)
    for pusher <- pushers, do: InteractiveTetris.StatePusher.stop(pusher)

    game = get_game_by_room_id(room_id)
    state = InteractiveTetris.Game.get_state(game)
    InteractiveTetris.Game.stop(game)

    room = Repo.get(Room, room_id)
    changeset = Room.changeset(room, %{ :score => state.points })

    Repo.update(changeset)

    :ets.match_delete(:interactive_tetris_active_games, {:"$1", room_id})
    :ets.match_delete(:interactive_tetris_active_pushers, {:"$1", room_id})
  end
end
