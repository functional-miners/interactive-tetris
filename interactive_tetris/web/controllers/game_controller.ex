defmodule InteractiveTetris.GameController do
  use InteractiveTetris.Web, :controller

  alias InteractiveTetris.Room
  alias InteractiveTetris.ConnectedGame
  alias InteractiveTetris.User

  def game(conn, %{"id" => id}) do
    room = Repo.get(Room, id)
    room = Ecto.Changeset.change(room, active: true)

    case Repo.update room do
      {:ok, _model} ->
        username = get_session(conn, :username)
        user = Repo.get_by(User, username: username)
        changeset = ConnectedGame.changeset(%ConnectedGame{ :user_id => user.id, :room_id => id })

        case Repo.insert(changeset) do
          {:ok, _model} ->
            conn
            |> put_flash(:info, "Game activated!")
            |> render("game.html", room: room)

          {:error, _changeset} ->
            conn
            |> render("game.html", room: room)
        end

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Game is not activated.")
        |> render("game.html", room: room)
    end
  end

  def summary(conn, %{"id" => id}) do
    room = Repo.get(Room, id)
    room = Repo.preload(room, :author)
    changeset = Ecto.Changeset.change(room, active: false, finished: true)

    case Repo.update(changeset) do
      {:ok, _model} ->
        conn
        |> put_flash(:info, "Game finished!")
        |> render("summary.html", room: room)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Game is not finished.")
        |> render("summary.html", room: room)
    end
  end
end
