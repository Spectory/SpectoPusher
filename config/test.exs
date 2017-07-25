use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :specto_pusher, SpectoPusher.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :specto_pusher, SpectoPusher.Repo,
  adapter: Sqlite.Ecto2,
  database: "db/specto_pusher_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox