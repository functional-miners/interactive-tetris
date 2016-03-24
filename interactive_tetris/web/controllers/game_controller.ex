defmodule InteractiveTetris.GameController do
  use InteractiveTetris.Web, :controller

  alias InteractiveTetris.Room

  def game(conn, %{"id" => id}) do
    room = Repo.get(Room, id)
    room = Ecto.Changeset.change(room, active: true)

    case Repo.update room do
      {:ok, _model} ->
        conn
        |> put_flash(:info, "Game activated!")
        |> render("game.html")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Game is not activated.")
        |> render("game.html")
    end
  end

  def summary(conn, %{"id" => id}) do
    room = Repo.get(Room, id)
    room = Repo.preload(room, :author)
    changeset = Ecto.Changeset.change(room, active: false, finished: true)

    case Repo.update changeset do
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
