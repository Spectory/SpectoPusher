defmodule CoyoteWeb.UserChannel do
  use Coyote.Constants
  use Phoenix.Channel
  alias Coyote.Cache
  alias CoyoteWeb.Topic
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
  Subscribe to a private topic by a given name. Name is validated aginst cache,
  and fall back to Topics DB table.
  Returns:
  - {:ok, welcome_message} when topic is valid.
  - {:error, reason} when topic is invalid.
  """
  def join(name, _params, socket) do
    topic = Cache.lookup(@user_channel_cache, name) || Topic
    |> Topic.by_name(String.trim name)
    |> Repo.one
    case topic do
      nil -> {:error, %{reason: "No Topic by name '#{name}'"}}
      _ ->
        # TODO: count the number of user at channel. See Phoenix.Presence docs.
        Cache.insert(@user_channel_cache, {topic, true})
        {:ok, %{msg: "welcome to #{name}"}, socket}
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