defmodule Coyote.Cache do
  use GenServer

  def start_link(cache_name) do
    GenServer.start_link(__MODULE__, cache_name, name: cache_name)
  end

  def insert(pid, {key, value}) do
    GenServer.call(pid, {:insert, {key, value}})
  end

  def lookup(pid, key) do
    GenServer.call(pid, {:lookup, key})
  end

  def remove(pid, key) do
    GenServer.call(pid, {:remove, key})
  end

  @impl true
  def init(cache_name) do
    {:ok, :ets.new(cache_name, [:named_table])}
  end

  @impl true
  def handle_call({:insert, {key, value}}, _from, cache) do
    :ets.insert(cache, {key, value})
    {:reply, :ok, cache}
  end

  @impl true
  def handle_call({:lookup, key}, _from, cache) do
    case :ets.lookup(cache, key) do
      [{_key, value}] -> {:reply, value, cache}
      [] -> {:reply, nil, cache}
    end
  end

  @impl true
  def handle_call({:remove, key}, _from, cache) do
    :ets.delete(cache, key)
    {:reply, :ok, cache}
  end
end