defmodule Coyote.Auth do
  alias CoyoteWeb.Endpoint
  alias Coyote.EnvHelper
  alias Phoenix.Token

  @day 86_400

  def authenticate(hash), do: EnvHelper.get_env("ACCESS_KEY") == hash

  def sign(data), do: Token.sign(Endpoint, salt(), data)

  def verify(token), do: Token.verify(Endpoint, salt(), token, max_age: @day)

  defp salt, do: EnvHelper.get_env("CRYPTO_SALT")
end