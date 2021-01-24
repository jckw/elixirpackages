defmodule ElixirPackages.Repo.Migrations.CreateGrids do
  use Ecto.Migration

  def change do
    create table(:grids) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
