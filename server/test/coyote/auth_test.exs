defmodule Coyote.AuthTest do
  use ExUnit.Case, async: true
  alias Coyote.Auth

  test "authenticate invalid hash" do
    refute Auth.authenticate("invalid")
  end

  test "authenticate valid hash" do
    assert Auth.authenticate(System.get_env("ACCESS_KEY"))
  end

  test "sign tokens" do
    assert is_binary Auth.sign("some value")
  end

  test "sign_all" do
    keys = [0, "1" , %{mama: "papa"}]
    tokens = Auth.sign_all keys
    assert Enum.at(tokens, 0) == Auth.sign Enum.at(keys, 0)
    assert Enum.at(tokens, 1) == Auth.sign Enum.at(keys, 1)
    assert Enum.at(tokens, 2) == Auth.sign Enum.at(keys, 2)
  end

  test "verify valid tokens" do
    key = %{some: "value"}
    token = Auth.sign(key)
    assert {:ok, %{some: "value"}} = Auth.verify(token)
  end

  test "verify invalid tokens" do
    assert {:error, :invalid} = Auth.verify("invalid token")
  end
end