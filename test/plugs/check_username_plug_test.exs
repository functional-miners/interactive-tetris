defmodule InteractiveTetris.CheckUsernameTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.ProcessStore

  @opts InteractiveTetris.CheckUsername.init(%{ "default" => "/default_path" })

  test "it should redirect to provided default path when there is no username in session data" do
    conn = conn(:get, "/rooms")
    opts = Plug.Session.init(store: ProcessStore, key: "session_key")
    conn = Plug.Session.call(conn, opts) |> fetch_session()

    conn = InteractiveTetris.CheckUsername.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 302

    assert Plug.Conn.get_resp_header(conn, "location") == [ "/default_path" ]
    assert Plug.Conn.get_resp_header(conn, "content-type") == [ "text/html" ]
    assert conn.resp_body == "<html><body>You are being <a href=\"/default_path\">redirected</a>.</body></html>"
  end

  test "it should move forward when username is available in session data" do
    conn = conn(:get, "/rooms")
    opts = Plug.Session.init(store: ProcessStore, key: "session_key")
    conn = Plug.Session.call(conn, opts) |> fetch_session()
    conn = put_session(conn, "username", "jerry")

    conn = InteractiveTetris.CheckUsername.call(conn, @opts)
    conn = send_resp(conn, 200, "CONTENT")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "CONTENT"
  end
end
