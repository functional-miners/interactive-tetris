defmodule InteractiveTetris.UserController do
  use InteractiveTetris.Web, :controller

  alias InteractiveTetris.User

  plug :scrub_params, "user" when action in [:enter]

  defp register_decision(conn, nil), do: render(conn, "register.html", changeset: User.changeset(%User{}))
  defp register_decision(conn, _), do: redirect(conn, to: room_path(conn, :index))

  def register(conn, _params), do: register_decision(conn, get_session(conn, :username))

  def enter(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_session(:username, user_params["username"])
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: room_path(conn, :index))

      {:error, changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def exit(conn, params) do
    Plug.Conn.configure_session(conn, drop: true)
    |> register(params)
  end
end
