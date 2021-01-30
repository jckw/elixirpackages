defmodule ElixirPackages.PackageGrids.SyncPackageGridsTest do
  use ElixirPackages.DataCase

  alias ElixirPackages.PackageGrids
  alias ElixirPackages.PackageGrids.SyncPackageData

  import Mock

  def fixture(:grid) do
    {:ok, package} = PackageGrids.create_package(%{name: "fake_package"})
    package
  end

  describe "genserver" do
    test "init schedules work" do
    end

    test "handle_info syncs and schedules work" do
    end
  end

  describe "hex sync" do
    test "does not error when request fails" do
    end
  end

  describe "repo data" do
    test "github is recognised in all valid formats" do
    end

    test "no match returns empty map" do
      assert SyncPackageData.get_repo_data_from_links(%{
               "not a vcs": "http://not-a-vcs.com/package"
             }) == %{}
    end
  end

  describe "github sync" do
    test "does not error when api call fails" do
    end
  end
end
