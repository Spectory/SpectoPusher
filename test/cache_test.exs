defmodule Coyote.CacheTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, cache_pid} = GenServer.start_link(Coyote.Cache, :test_cache)
    %{cache: cache_pid}
  end

  test "insert", %{cache: cache_pid} do
    assert Coyote.Cache.insert(cache_pid, {:key, "value"}) == :ok
  end

  test "lookup", %{cache: cache_pid} do
    Coyote.Cache.insert(cache_pid, {:key, "value"})
    assert Coyote.Cache.lookup(cache_pid, :key) == "value"
    assert Coyote.Cache.lookup(cache_pid, :no_such_key) == nil
  end

  test "value overrides", %{cache: cache_pid} do
    Coyote.Cache.insert(cache_pid, {:key, "value"})
    Coyote.Cache.insert(cache_pid, {:key, "value2"})
    assert Coyote.Cache.lookup(cache_pid, :key) == "value2"
  end

  test "remove", %{cache: cache_pid} do
    Coyote.Cache.insert(cache_pid, {:key, "value"})
    assert Coyote.Cache.remove(cache_pid, :key) == :ok
    assert Coyote.Cache.lookup(cache_pid, :key) == nil
  end
end