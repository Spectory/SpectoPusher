defmodule Coyote.UserChannel do
  use Phoenix.Channel
  alias Coyote.Topic
  alias Coyote.Repo

  @doc """
  Subscribe to a public topic, by the name `"public:*"`. Anyone can subscribe to
  pubic topics.
  """
  def join("public:" <> name, _params, socket) do
    case String.trim(name) do
      "" -> {:error, %{reason: "No public name provided. format must by `public:name`"}}
      _ -> {:ok, %{msg: "welcome to public:#{name}"}, socket}
    end
  end

  @doc """
  Subscribe to a private topic by a given name. Name is validated aginst DB.
  Returns:
  - {:ok, welcome_message} when topic is valid.
  - {:error, reason} when topic is invalid.
  """
  def join(name, _params, socket) do
    # TODO: we can keep topics in memory instead of searching the DB on every
    # join request. should be much faster.
    topic = Topic
      |> Topic.by_name(String.trim name)
      |> Repo.one
    case topic do
      nil -> {:error, %{reason: "No Topic by name '#{name}'"}}
      _ -> {:ok, %{msg: "welcome to #{name}"}, socket}
    end
  end

  @doc """
  Broadcasts given payload to everyone on the channel, expect for the user that
  sent the message.
  """
  def handle_in("broadcast", payload, socket) do
      broadcast_from! socket, "broadcast", payload
      {:noreply, socket}
  end

  @doc """
  Broadcasts given payload to everyone on the channel, including to the user
  that sent the message.
  """
  def handle_in("broadcast!", payload, socket) do
      broadcast! socket, "broadcast!", payload
      {:noreply, socket}
  end
end