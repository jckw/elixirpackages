defmodule ElixirPackages.PackageGrids.Grid do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirPackages.PackageGrids.{Package, PackageInGrid}

  @derive {Phoenix.Param, key: :slug}
  schema "grids" do
    field :name, :string
    field :description, :string
    field :slug, :string

    many_to_many :packages, Package, join_through: PackageInGrid

    timestamps()
  end

  @doc false
  def changeset(grid, attrs) do
    grid
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description, :slug])
  end
end
