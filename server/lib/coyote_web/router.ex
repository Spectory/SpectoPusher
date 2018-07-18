defmodule CoyoteWeb.Router do
  use CoyoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_access do
    plug CoyoteWeb.AccessPlug
  end

  pipeline :require_api_access do
    plug CoyoteWeb.AccessApiPlug
  end

  scope "/", CoyoteWeb do
    pipe_through :browser
    get "/", PageController, :index
    post "/login", PageController, :login

  end

  scope "/admin", CoyoteWeb do
    pipe_through :browser # TODO should pipe through auth.
    get "/", AdminController, :index
    post "/create_topic", AdminController, :create_topic
  end

  # Other scopes may use custom stacks.
  scope "/api", CoyoteWeb do
    pipe_through [:api, :require_api_access]
    get "/tokens", TokenController, :index
  end
end
