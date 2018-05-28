defmodule Coyote.Auth do
  alias CoyoteWeb.Endpoint
  alias Phoenix.Token

  @day 86400

  def authenticate(hash), do: System.get_env("ACCESS_KEY") == hash

  def sign(data), do: Token.sign(Endpoint, salt(), data)

  def verify(token), do: Token.verify(Endpoint, salt(), token, max_age: @day)

  defp salt, do: System.get_env("CRYPTO_SALT")
end