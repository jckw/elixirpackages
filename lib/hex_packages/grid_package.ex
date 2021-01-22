defmodule HexPackages.GridPackage do
  use Ecto.Schema
  import Ecto.Changeset
  alias HexPackages.Repo
  alias HexPackages.GridPackage

  @primary_key false
  schema "grid_packages" do
    field :grid, :id
    field :package, :id

    timestamps()
  end

  @doc false
  def changeset(grid_package, attrs) do
    grid_package
    |> cast(attrs, [:grid, :package])
    |> validate_required([:grid, :package])
    |> unique_constraint(:no_duplicate_packages, name: :grid_package_index)
  end

  def create(attrs) do
    %GridPackage{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
