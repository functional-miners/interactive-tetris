defmodule InteractiveTetris.UserControllerTest do
  use InteractiveTetris.ConnCase

  test "that default handler should point to registration page", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Who are you?"
  end
end
