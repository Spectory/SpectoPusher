defmodule CoyoteWeb.PageController do
  use CoyoteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, %{"credentials" => %{"password" => password}}) do
    case Coyote.Auth.authenticate(password) do
      true -> conn
        |> put_session(:has_access, true)
        |> Phoenix.Controller.redirect(to: "/admin")
      false ->  conn
        |> put_flash(:error, "Access key doesn't match ACCESS_KEY env variable.")
        |> render("index.html")
    end
  end
end
