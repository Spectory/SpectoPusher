defmodule Coyote.GenericChannel do
  use Phoenix.Channel
  alias Coyote.Topic
  alias Coyote.Repo

  def join("public:" <> name, _params, socket) do
    case String.trim(name) do
      "" -> {:error, %{reason: "No public name provided. format must by `public:name`"}}
      _ -> {:ok, %{msg: "welcome to public:#{name}"}, socket}
    end
  end

  def join(name, _params, socket) do
    # TODO: we can keep topics in memory instead of searching the DB on every join request. should be much faster.
    topic = Topic
      |> Topic.by_name(String.trim name)
      |> Repo.one
    case topic do
      nil -> {:error, %{reason: "No Topic by name '#{name}'"}}
      _ -> {:ok, %{msg: "welcome to #{name}"}, socket}
    end
  end

  # broadcast!/3 will notify all joined clients on this
  # socket's topic and invoke their handle_out/3 callbacks
  def handle_in("new_msg", %{"body" => body}, socket) do
      broadcast_from! socket, "new_msg", %{body: body}
      {:noreply, socket}
  end

  # TODO: Add and event that use `broadcast` instead of broadcast all.
end