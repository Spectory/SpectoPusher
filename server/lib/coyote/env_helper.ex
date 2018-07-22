defmodule Coyote.EnvHelper do
  require Logger

  @base_vars ~w(ACCESS_KEY CRYPTO_SALT)
<<<<<<< HEAD
  @prod_vars @base_vars ++ ~w(HOST SECRET_KEY_BASE)
=======
  @prod_vars @base_vars ++ ~w(SECRET_KEY_BASE)
>>>>>>> 4b2ec3bb0dc746b267dbe063280dbdcbb1c41eb4
  @dev_var @base_vars
  @test_var @base_vars
  @envs %{prod: @prod_vars, dev: @dev_var, test: @test_var}

  def verify_env(env) do
    @envs
    |> Map.get(env)
    |> Enum.each(&verify/1)
  end

  def get_env(key, default \\ nil) do
    case System.get_env(key) do
      nil -> default
      val -> val
    end
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
