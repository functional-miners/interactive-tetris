defmodule InteractiveTetris.CheckUsername do
  import Plug.Conn

  def init(options), do: options

  defp redirect(conn, url) do
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> put_resp_header("content-type", "text/html")
    |> send_resp(conn.status || 302, body)
  end

  defp make_decision(conn, default_path, nil), do: redirect(conn, default_path)
  defp make_decision(conn, _, _), do: conn

  def call(conn, %{ "default" => path }), do: make_decision(conn, path, get_session(conn, :username))
end
