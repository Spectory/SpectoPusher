defmodule Coyote.PageController do
  use Coyote.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
