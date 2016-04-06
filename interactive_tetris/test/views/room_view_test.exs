defmodule InteractiveTetris.RoomViewTest do
  use InteractiveTetris.ConnCase, async: true

  alias Plug.ProcessStore
  alias InteractiveTetris.Room
  alias InteractiveTetris.User

  test "active_room() helper should return proper class name based on Room activity" do
    assert InteractiveTetris.RoomView.active_room(%Room{ :active => false, :finished => false }) == "ready-row"
    assert InteractiveTetris.RoomView.active_room(%Room{ :active => true, :finished => false }) == "active-row"
    assert InteractiveTetris.RoomView.active_room(%Room{ :active => true, :finished => true }) == "inactive-row"
    assert InteractiveTetris.RoomView.active_room(%Room{ :active => false, :finished => true }) == "inactive-row"
  end

  test "is_current_user_an_author() should compare currently logged user and Room author" do
    conn = conn(:get, "/rooms")
    opts = Plug.Session.init(store: ProcessStore, key: "session_key")
    conn = Plug.Session.call(conn, opts) |> fetch_session()

    room = %Room{ :author => %User{ :username => "jerry" } }

    assert InteractiveTetris.RoomView.is_current_user_an_author(conn, room) == false

    conn = put_session(conn, "username", "not_jerry")
    assert InteractiveTetris.RoomView.is_current_user_an_author(conn, room) == false

    conn = put_session(conn, "username", "jerry")
    assert InteractiveTetris.RoomView.is_current_user_an_author(conn, room) == true
  end
end
