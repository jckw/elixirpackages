defmodule HexPackages.Grid do
  use Ecto.Schema
  import Ecto.Changeset
  alias HexPackages.Repo
  alias HexPackages.{Grid, Package, GridPackage}

  schema "grids" do
    field :description, :string
    field :name, :string
    many_to_many :packages, Package, join_through: GridPackage, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(grid, attrs) do
    grid
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

  def create(attrs) do
    %Grid{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
