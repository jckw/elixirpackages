defmodule HexPackages.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HexPackages.Repo,
      # Start the Telemetry supervisor
      HexPackagesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HexPackages.PubSub},
      # Start the Endpoint (http/https)
      HexPackagesWeb.Endpoint
      # Start a worker by calling: HexPackages.Worker.start_link(arg)
      # {HexPackages.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HexPackages.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HexPackagesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
