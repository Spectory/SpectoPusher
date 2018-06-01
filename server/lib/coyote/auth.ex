defmodule Coyote.Auth do
  alias CoyoteWeb.Endpoint
  alias Coyote.EnvHelper
  alias Phoenix.Token

  @day 86_400

  def authenticate(hash), do: EnvHelper.get_env("ACCESS_KEY") == hash

  def sign(data) when not is_nil(data), do: Token.sign(Endpoint, salt(), data)

  def sign_all(lst) when is_list(lst), do: Enum.map(lst, &(sign &1))

  def verify(token), do: Token.verify(Endpoint, salt(), token, max_age: @day)

  defp salt, do: EnvHelper.get_env("CRYPTO_SALT")
end
