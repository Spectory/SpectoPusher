# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :specto_pusher,
  ecto_repos: [SpectoPusher.Repo]

# Configures the endpoint
config :specto_pusher, SpectoPusher.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HgTCOwl642x3g+hXp540EzVFDIcXd/eLKdHZeACbybEbnJdy/JN49Y7NgLz/9CSL",
  render_errors: [view: SpectoPusher.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SpectoPusher.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :ex_admin,
  repo: SpectoPusher.Repo,
  module: SpectoPusher,
  modules: [
    SpectoPusher.ExAdmin.Dashboard,
    SpectoPusher.ExAdmin.Topic,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

