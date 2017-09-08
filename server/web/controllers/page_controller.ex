defmodule SpectoPusher.PageController do
  use SpectoPusher.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
