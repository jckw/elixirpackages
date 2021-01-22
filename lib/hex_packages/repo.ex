defmodule HexPackages.Repo do
  use Ecto.Repo,
    otp_app: :hex_packages,
    adapter: Ecto.Adapters.Postgres
end
