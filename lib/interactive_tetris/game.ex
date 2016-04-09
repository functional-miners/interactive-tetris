defmodule InteractiveTetris.Game do
  use GenServer

  alias InteractiveTetris.Shapes
  alias InteractiveTetris.Game.State
  alias InteractiveTetris.Game.Interaction

  @game_tick 500

  def start_link(room) do
    GenServer.start_link(__MODULE__, room)
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def update_room(pid, room) do
    GenServer.call(pid, {:update_room, room})
  end

  def handle_input(pid, input) do
    GenServer.cast(pid, {:handle_input, input})
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def init(room) do
    :timer.send_interval(@game_tick, self(), :tick)

    {:ok, %State{
        board: [
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        ],
        next: Shapes.random,
        current: Shapes.random,
        rotation: 0,
        room: room,
        active: true,
        points: 0,
        x: 8,
        y: 0
        }
    }
  end

  def handle_call({:update_room, room}, _from, state) do
    new_state = %State{state | room: room}
    reply_state = %{
      board: board_with_overlaid_shape(new_state),
      next: Shapes.get(new_state.next, 0) |> colorize(new_state.next),
      name: new_state.room.name,
      points: new_state.points,
      active: new_state.active,
      connected_users: length(new_state.room.connected_users),
    }

    {:reply, reply_state, new_state}
  end

  def handle_call(:get_state, _from, state) do
    reply_state = %{
      board: board_with_overlaid_shape(state),
      next: Shapes.get(state.next, 0) |> colorize(state.next),
      name: state.room.name,
      points: state.points,
      active: state.active,
      connected_users: length(state.room.connected_users),
    }

    {:reply, reply_state, state}
  end

  def handle_cast({:handle_input, input}, state) do
    {:noreply, Interaction.handle_input(state, input)}
  end

  def handle_info(:tick, state) do
    {:noreply, tick_game(state)}
  end

  def board_with_overlaid_shape(%State{} = state) do
    for {row, row_i} <- Enum.with_index(state.board) do
      for {col, col_i} <- Enum.with_index(row) do
        rotated_shape_overlaps_cell = Enum.member?(State.cells_for_shape(state), {col_i, row_i})
        cond do
          rotated_shape_overlaps_cell -> Shapes.number(state.current)
          true -> col
        end
      end
    end
  end

  def tick_game(state) do
    cond do
      collision_with_bottom?(state) || collision_with_board?(state) ->
        new_state = %State{state | board: board_with_overlaid_shape(state) }
        cleared_state = State.clear_lines(new_state)
        active = State.still_playable?(new_state)
        %State{cleared_state | current: state.next, x: 8, y: 0, next: Shapes.random, rotation: 0, active: active}

      :else ->
        %State{state | y: state.y + 1}
    end
  end

  def collision_with_bottom?(state) do
    Shapes.height(state.current, state.rotation) + state.y > 22
  end

  def collision_with_board?(state) do
    next_coords = for {x, y} <- State.cells_for_shape(state), do: {x, y + 1}
    Enum.any?(next_coords, fn(coords) ->
      State.cell_at(state, coords) != 0
    end)
  end

  def colorize(shape_list, name) do
    for row <- shape_list do
      for col <- row do
        col * Shapes.number(name)
      end
    end
  end
end
