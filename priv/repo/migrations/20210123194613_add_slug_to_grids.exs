defmodule HexPackages.Repo.Migrations.AddSlugToGrids do
  use Ecto.Migration

  def change do
    alter table(:grids) do
      add :slug, :string
    end

    create index(:grids, [:slug], unique: true)
  end
end
