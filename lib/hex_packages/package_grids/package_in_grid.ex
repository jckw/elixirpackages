defmodule HexPackages.PackageGrids.PackageInGrid do
  use Ecto.Schema
  import Ecto.Changeset
  alias HexPackages.PackageGrids.{Grid, Package}

  @primary_key false
  schema "package_in_grid" do
    # field :grid_id, :id
    # field :package_id, :id
    belongs_to :grid, Grid
    belongs_to :package, Package

    timestamps()
  end

  @doc false
  def changeset(package_in_grid, attrs) do
    package_in_grid
    |> cast(attrs, [:grid_id, :package_id])
    |> validate_required([:grid_id, :package_id])
  end
end
