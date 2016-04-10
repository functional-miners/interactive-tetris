defmodule InteractiveTetris.GameSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000
  channel "tetris", InteractiveTetris.GameChannel

  def connect(_params, socket), do: {:ok, socket}
  def id(_socket), do: nil
end
