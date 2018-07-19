defmodule CoyoteWeb.UserSocket do
  require Logger
  use Phoenix.Socket

  ## Channels
  channel "*", CoyoteWeb.UserChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000
  # transport :longpoll, Phoenix.Transports.LongPoll

  @doc """
  Establishes a socket connection.
  If env var UNSECURED_SOCKET == true, allow connection without authentication.
  """
  def connect(params, socket) do
    case Coyote.EnvHelper.get_env("UNSECURED_SOCKET") do
      "true" -> unsecure_connection(socket)
      _ -> connect_secure(params, socket)
    end
  end

  defp unsecure_connection(socket) do
    Logger.warn("#{__MODULE__}.unsecure_connection: Socket connected")
    {:ok, socket}
  end

  defp connect_secure(%{"token" => token}, socket) do
    case Coyote.Auth.verify token do
      {:ok, _} -> {:ok, socket}
      _ -> :error
    end
  end
  defp connect_secure(_params, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Coyote.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
