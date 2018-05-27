defmodule CoyoteWeb.AccessPlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case get_session(conn, :has_access) do
      true -> conn
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
      |> put_resp_content_type("text/plain")
      |> send_resp(401, "Unauthorized! Please login")
      |> halt
  end
end
