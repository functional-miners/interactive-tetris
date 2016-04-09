use Mix.Config

config :interactive_tetris, InteractiveTetris.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "qQPRPUgAyAqhciMDBeFSDKaPCnyW3ez+Izquo9VvO8CXVhMmuPW/03UnKVjBgXbl",
  render_errors: [accepts: ~w(html json)],
  http: [acceptors: 2],
  pubsub: [name: InteractiveTetris.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"

config :phoenix, :generators,
  migration: true,
  binary_id: true
