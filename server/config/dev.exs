use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :coyote, CoyoteWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/webpack/bin/webpack.js", "--watch", "--color",
                    cd: Path.expand("../assets", __DIR__)]]



# Watch static and templates for browser reloading.
config :coyote, CoyoteWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/coyote_web/views/.*(ex)$},
      ~r{lib/coyote_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :coyote, Coyote.Repo,
  adapter: Sqlite.Ecto2,
  database: "db/coyote_dev.sqlite3"

# Dummy access key, for admin login and API requests.
System.put_env("ACCESS_KEY", "letmein")
# Dummy crypto salt, used to sign/verify tokens.
System.put_env("CRYPTO_SALT", "crypto_salt")
# Dummy crypto salt, used to sign/verify tokens.
System.put_env("UNSECURE_SOCKET", "true")