defmodule Coyote.EnvHelper do
  require Logger

  @prod_vars ~w(ACCESS_KEY SECRET_KEY_BASE)
  @dev_var ~w(ACCESS_KEY)
  @test_var ~w(ACCESS_KEY)
  @envs %{prod: @prod_vars, dev: @dev_var, test: @test_var}

  def verify_env(env) do
    @envs
    |> Map.get(env)
    |> Enum.each(&verify/1)
  end

  defp verify(var) do
    unless System.get_env(var) do
      Logger.error("#{__MODULE__}.verify: #{var} must be set at #{Mix.env}!
      if running at prodction:
        - make sure ENV var are set.
      if local/dev:
        - set ENV vars at dev.exs
      if test:
        - set ENV vars at test.exs
      ")
    end
  end
end
