defmodule HexPackages.Repo.Migrations.CreateGridPackages do
  use Ecto.Migration

  def change do
    create table(:grid_packages, primary_key: false) do
      add :grid, references(:grids, on_delete: :delete_all), primary_key: true
      add :package, references(:packages, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create index(:grid_packages, [:grid])
    create index(:grid_packages, [:package])
    create unique_index(:grid_packages, [:grid, :package], name: :grid_package_unique_index)
  end
end
