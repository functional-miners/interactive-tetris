defmodule InteractiveTetris.LayoutViewTest do
  use InteractiveTetris.ConnCase, async: true

  alias Plug.ProcessStore

  test "get_username() helper should return username stored in session" do
    conn = conn(:get, "/rooms")
    opts = Plug.Session.init(store: ProcessStore, key: "session_key")
    conn = Plug.Session.call(conn, opts) |> fetch_session()

    assert InteractiveTetris.LayoutView.get_username(conn) == nil

    conn = put_session(conn, "username", "jerry")

    assert InteractiveTetris.LayoutView.get_username(conn) == "jerry"
  end

  test "logged() helper should check if username is set at all" do
    conn = conn(:get, "/rooms")
    opts = Plug.Session.init(store: ProcessStore, key: "session_key")
    conn = Plug.Session.call(conn, opts) |> fetch_session()

    assert InteractiveTetris.LayoutView.logged(conn) == false

    conn = put_session(conn, "username", "jerry")

    assert InteractiveTetris.LayoutView.logged(conn) == true
  end
end
