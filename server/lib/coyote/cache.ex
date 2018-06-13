defmodule Coyote.Cache do
  @moduledoc """
  Provides cache object.
  Cache can be persisted by saving to file.

  ## Examples
      iex> Coyote.Cache.start_link(:my_cache, true)
      {:ok, #PID<0.276.0>}
      iex> Coyote.Cache.insert(:my_cache, {"some_key": "some_value"})
      iex> Coyote.Cache.insert(:my_cache, {"some_key", "some_value"})
      :ok
      iex> Coyote.Cache.lookup(:my_cache, "some_key")
      "some_value"
      iex> Coyote.Cache.to_list(:my_cache, "some_key")
      [{"some_key", "some_value"}]
  """
  use GenServer

  @dets_storage_folder "dets"

  def start_link(cache_name, load_from_dets \\ false) do
    GenServer.start_link(__MODULE__, {cache_name, load_from_dets}, name: cache_name)
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

  def to_file(pid) do
    GenServer.call(pid, {:to_file})
  end

  def from_file(pid) do
    GenServer.call(pid, {:from_file})
  end

  def to_list(pid) do
    GenServer.call(pid, {:to_list})
  end

  @impl true
  def init({cache_name, from_file}) do
    cache = :ets.new(cache_name, [:named_table])
    case (from_file) do
      true -> {:ok, load_from_file(cache_name)}
      false -> {:ok, cache}
    end
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

  @impl true
  def handle_call({:to_file}, _from, cache) do
    save_to_file(cache)
    {:reply, :ok, cache}
  end

  @impl true
  def handle_call({:from_file}, _from, cache) do
    cache = load_from_file(cache)
    {:reply, :ok, cache}
  end

  @impl true
  def handle_call({:to_list}, _from, cache) do
    {:reply, :ets.tab2list(cache), cache}
  end

  defp save_to_file(cache) do
    {:ok, table} = :dets.open_file(file_name(cache), [type: :set])
    :ets.to_dets(cache, table)
    :dets.close(table)
  end

  defp load_from_file(cache) do
    {:ok, table} = :dets.open_file(file_name(cache), [type: :set])
    cache = :dets.to_ets(table, cache)
    :dets.close(table)
    cache
  end

  defp file_name(cache_name), do:
      Enum.join([@dets_storage_folder, cache_name], "/")
end