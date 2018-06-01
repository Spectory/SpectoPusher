defmodule CoyoteWeb.TokenControllerTest do
  use CoyoteWeb.ConnCase

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("access_key", System.get_env("ACCESS_KEY"))
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    params = %{keys: "[1, 2, 3]"}
    conn = get conn, token_path(conn, :index), params
    %{"tokens" => tokens} = json_response(conn, 200)
    assert is_list(tokens)
  end
end