defmodule CoyoteWeb.AdminController do
  use CoyoteWeb, :controller
  use Coyote.Constants

  def index(conn, _params) do
    render_index(conn)
  end

  def create_topic(conn, %{"topic" => %{"name" => name}}) do
    create_topic(name)
    redirect conn, to: "/admin"
  end

  defp create_topic(name) do
    Coyote.Cache.insert(@user_channel_cache, {name, 0})
    Coyote.Cache.to_file(@user_channel_cache)
  end

  defp render_index(conn) do
    topics = @user_channel_cache
      |> Coyote.Cache.to_list
      |> Enum.map(&(Tuple.to_list &1))
<<<<<<< HEAD
      |> Enum.map(&(List.first &1))
      |> Enum.sort
=======
>>>>>>> 44ffe808ef5698a932f3bc905202361206ba0910
    render conn, "index.html", topics: topics
  end
end
