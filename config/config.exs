# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_packages,
  ecto_repos: [ElixirPackages.Repo]

# Configures the endpoint
config :elixir_packages, ElixirPackagesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BtesetcnBZxLoET6RKpFkoj/moec+Io6tlKUH9nigX3PLDaafzipH8A4DA+Sl+hs",
  render_errors: [view: ElixirPackagesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ElixirPackages.PubSub,
  live_view: [signing_salt: "bkMgeOtA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
  otp_app: :elixir_packages,
  template_format: "eex"

config :elixir_packages, :pow,
  user: ElixirPackages.Users.User,
  repo: ElixirPackages.Repo,
  routes_backend: ElixirPackagesWeb.Pow.Routes

config :elixir_packages, :pow_assent,
  providers: [
    github: [
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      strategy: Assent.Strategy.Github
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
