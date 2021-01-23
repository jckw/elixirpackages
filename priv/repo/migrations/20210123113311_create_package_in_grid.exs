defmodule HexPackages.Repo.Migrations.CreatePackageInGrid do
  use Ecto.Migration

  def change do
    create table(:package_in_grid, primary_key: false) do
      add :grid_id, references(:grids, on_delete: :nothing)
      add :package_id, references(:packages, on_delete: :nothing)

      timestamps()
    end

    create index(:package_in_grid, [:grid_id])
    create index(:package_in_grid, [:package_id])
    create unique_index(:package_in_grid, [:grid_id, :package_id], name: :grid_id_package_id_unique)
  end
end
