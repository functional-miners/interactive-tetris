use Mix.Config

config :interactive_tetris, InteractiveTetris.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :interactive_tetris, InteractiveTetris.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "interactive_tetris_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
