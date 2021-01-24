defmodule ElixirPackages.Repo.Migrations.AddSyncablePackageFields do
  use Ecto.Migration

  def change do
    alter table(:packages) do
      add :description, :text
      add :hex_url, :string
      add :last_released, :utc_datetime
      add :latest_version, :string
      add :latest_stable_version, :string
      add :repo_provider, :string
      add :repo_url, :string
      add :stars_count, :integer
      add :forks_count, :integer
      add :issues_count, :integer
    end
  end
end
