defmodule CoyoteWeb.TokenController do
  use CoyoteWeb, :controller

  def index(conn, %{"keys" => keys}) do
    keys = Poison.decode! keys
    json conn, %{tokens: Coyote.Auth.sign_all(keys)}
  end
end
