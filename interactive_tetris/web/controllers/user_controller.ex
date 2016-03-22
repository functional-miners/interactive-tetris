defmodule InteractiveTetris.UserController do
  use InteractiveTetris.Web, :controller

  alias InteractiveTetris.User

  plug :scrub_params, "user" when action in [:enter, :exit]

  def register(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

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

  def exit(conn, _params) do
    user_path(conn, :register)
  end
end
