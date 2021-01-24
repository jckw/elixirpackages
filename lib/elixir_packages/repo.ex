defmodule ElixirPackages.Repo do
  use Ecto.Repo,
    otp_app: :elixir_packages,
    adapter: Ecto.Adapters.Postgres
end
