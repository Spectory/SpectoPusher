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

  test "verify valid tokens" do
    key = %{some: "value"}
    token = Auth.sign(key)
    assert {:ok, %{some: "value"}} = Auth.verify(token)
  end

  test "verify invalid tokens" do
    assert {:error, :invalid} = Auth.verify("invalid token")
  end
end