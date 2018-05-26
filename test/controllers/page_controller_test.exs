defmodule CoyoteWeb.PageControllerTest do
  use CoyoteWeb.ConnCase

  test "GET / without access", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Please enter access key"
  end

  test "POST /login with invalid password", %{conn: conn} do
    conn = post conn, "/login", %{"credentials" => %{"password" => ""}}
    assert html_response(conn, 200) =~ "Please enter access key"
  end

  test "POST /login with valid password", %{conn: conn} do
    params = %{"credentials" => %{"password" => System.get_env("ACCESS_KEY")}}
    conn = post conn, "/login", params
    assert redirected_to(conn, 302) == "/admin"
  end
end
