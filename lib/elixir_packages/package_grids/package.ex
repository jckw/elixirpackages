defmodule ElixirPackages.PackageGrids.Package do
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
    field :name, :string
    field :description, :string
    field :hex_url, :string
    field :last_released, :utc_datetime
    field :latest_version, :string
    field :latest_stable_version, :string
    field :repo_provider, :string
    field :repo_url, :string
    field :stars_count, :integer
    field :forks_count, :integer
    field :issues_count, :integer

    timestamps()
  end

  @doc false
  def changeset(package, attrs) do
    package
    |> cast(attrs, [
      :name,
      :description,
      :hex_url,
      :last_released,
      :latest_version,
      :latest_stable_version,
      :repo_provider,
      :repo_url,
      :stars_count,
      :forks_count,
      :issues_count
    ])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
