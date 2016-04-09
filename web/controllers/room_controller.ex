defmodule InteractiveTetris.RoomController do
  use InteractiveTetris.Web, :controller

  alias InteractiveTetris.Room
  alias InteractiveTetris.User

  plug :scrub_params, "room" when action in [:create]

  def index(conn, _params) do
    rooms = Repo.all(Room)
    rooms = Repo.preload(rooms, [:author, :connected_users])

    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    username = get_session(conn, :username)
    user = Repo.get_by(User, username: username)

    changeset = Room.changeset(%Room{:author_id => user.id}, room_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: room_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)

    Repo.delete!(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: room_path(conn, :index))
  end

  def join(conn, %{"id" => id}) do
    room = Repo.get(Room, id)
    room = Repo.preload(room, [:author, :connected_users])

    render(conn, "join.html", room: room)
  end
end
