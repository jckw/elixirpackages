defmodule HexPackagesWeb.Router do
  use HexPackagesWeb, :router

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

  scope "/", HexPackagesWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/grids", GridController, only: [:show]
  end

  scope "/admin", HexPackagesWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/packages", PackageController

    resources "/grids", GridController do
      get "/add_package", GridController, :add_package, as: :add_package
      post "/add_package", GridController, :save_package, as: :add_package
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HexPackagesWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HexPackagesWeb.Telemetry
    end
  end
end
