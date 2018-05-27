defmodule Coyote.AuthTest do
  use ExUnit.Case, async: true

  test "invalid hash" do
    refute Coyote.Auth.authenticate("invalid")
  end

  test "valid hash" do
    assert Coyote.Auth.authenticate(System.get_env("ACCESS_KEY"))
  end
end