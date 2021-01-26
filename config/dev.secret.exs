use Mix.Config

github_access_token =
  config :elixir_packages,
    github_access_token: "YOUR_ACCESS_TOKEN"

config :elixir_packages, :pow_assent,
  providers: [
    github: [
      client_id: "YOUR_CLIENT_ID",
      client_secret: "YOUR_CLIENT_SECRET",
      strategy: Assent.Strategy.Github
    ]
  ]
