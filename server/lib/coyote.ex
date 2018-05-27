defmodule Coyote do
  use Application
  use Coyote.Constants

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Coyote.Repo, []),
      # Start the endpoint when the application starts
      supervisor(CoyoteWeb.Endpoint, []),
      # Start your own worker by calling: Coyote.Worker.start_link(arg1, arg2, arg3)
      worker(Coyote.Cache, [@user_channel_cache]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Coyote.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Coyote.Endpoint.config_change(changed, removed)
    :ok
  end

  # Make sure ENV vars are set correctly.
  Coyote.EnvHelper.verify_env(Mix.env)
end
