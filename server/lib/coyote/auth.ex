defmodule Coyote.Auth do
  def authenticate(hash), do: System.get_env("ACCESS_KEY") == hash
end