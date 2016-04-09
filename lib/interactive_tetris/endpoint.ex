defmodule InteractiveTetris.Endpoint do
  use Phoenix.Endpoint, otp_app: :interactive_tetris

  socket "/ws", InteractiveTetris.GameSocket

  plug Plug.Static,
    at: "/", from: :interactive_tetris, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_interactive_tetris_key",
    signing_salt: "JqsoM01R"

  plug InteractiveTetris.Router
end
