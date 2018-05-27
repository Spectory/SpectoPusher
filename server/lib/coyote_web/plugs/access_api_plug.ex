defmodule CoyoteWeb.AccessApiPlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    access_key = List.keyfind(conn.req_headers, "access_key", 0)
      |> getAccessKeyFromHeader
    case Coyote.Auth.authenticate(access_key) do
      true -> conn
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
      |> put_resp_content_type("text/plain")
      |> send_resp(401, "Invalid access key")
      |> halt
  end

  defp getAccessKeyFromHeader({"access_key", hash}), do: hash
  defp getAccessKeyFromHeader(nil), do: nil
end
