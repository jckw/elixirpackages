defmodule ElixirPackages.PackageGridsTest do
  use ElixirPackages.DataCase

  alias ElixirPackages.PackageGrids

  describe "grids" do
    alias ElixirPackages.PackageGrids.Grid

    @valid_attrs %{description: "some description", name: "some name", slug: "some-name"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      slug: "some-updated-name"
    }
    @invalid_attrs %{description: nil, name: nil, slug: nil}

    def grid_fixture(attrs \\ %{}) do
      {:ok, grid} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PackageGrids.create_grid()

      grid
    end

    test "paginate_grids/1 returns paginated list of grids" do
      for i <- 1..20 do
        grid_fixture(name: "Grid #{i}", slug: "grid-#{i}")
      end

      {:ok, %{grids: grids} = page} = PackageGrids.paginate_grids(%{})

      assert length(grids) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_grids/0 returns all grids" do
      grid = grid_fixture()
      assert PackageGrids.list_grids() == [grid]
    end

    test "get_grid!/1 returns the grid with given id" do
      grid = grid_fixture()
      assert PackageGrids.get_grid!(grid.id) == grid
    end

    test "create_grid/1 with valid data creates a grid" do
      assert {:ok, %Grid{} = grid} = PackageGrids.create_grid(@valid_attrs)
      assert grid.description == "some description"
      assert grid.name == "some name"
    end

    test "create_grid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PackageGrids.create_grid(@invalid_attrs)
    end

    test "update_grid/2 with valid data updates the grid" do
      grid = grid_fixture()
      assert {:ok, grid} = PackageGrids.update_grid(grid, @update_attrs)
      assert %Grid{} = grid
      assert grid.description == "some updated description"
      assert grid.name == "some updated name"
    end

    test "update_grid/2 with invalid data returns error changeset" do
      grid = grid_fixture()
      assert {:error, %Ecto.Changeset{}} = PackageGrids.update_grid(grid, @invalid_attrs)
      assert grid == PackageGrids.get_grid!(grid.id)
    end

    test "delete_grid/1 deletes the grid" do
      grid = grid_fixture()
      assert {:ok, %Grid{}} = PackageGrids.delete_grid(grid)
      assert_raise Ecto.NoResultsError, fn -> PackageGrids.get_grid!(grid.id) end
    end

    test "change_grid/1 returns a grid changeset" do
      grid = grid_fixture()
      assert %Ecto.Changeset{} = PackageGrids.change_grid(grid)
    end
  end

  describe "packages" do
    alias ElixirPackages.PackageGrids.Package

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def package_fixture(attrs \\ %{}) do
      {:ok, package} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PackageGrids.create_package()

      package
    end

    test "paginate_packages/1 returns paginated list of packages" do
      for _ <- 1..20 do
        package_fixture()
      end

      {:ok, %{packages: packages} = page} = PackageGrids.paginate_packages(%{})

      assert length(packages) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_packages/0 returns all packages" do
      package = package_fixture()
      assert PackageGrids.list_packages() == [package]
    end

    test "get_package!/1 returns the package with given id" do
      package = package_fixture()
      assert PackageGrids.get_package!(package.id) == package
    end

    test "create_package/1 with valid data creates a package" do
      assert {:ok, %Package{} = package} = PackageGrids.create_package(@valid_attrs)
      assert package.name == "some name"
    end

    test "create_package/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PackageGrids.create_package(@invalid_attrs)
    end

    test "update_package/2 with valid data updates the package" do
      package = package_fixture()
      assert {:ok, package} = PackageGrids.update_package(package, @update_attrs)
      assert %Package{} = package
      assert package.name == "some updated name"
    end

    test "update_package/2 with invalid data returns error changeset" do
      package = package_fixture()
      assert {:error, %Ecto.Changeset{}} = PackageGrids.update_package(package, @invalid_attrs)
      assert package == PackageGrids.get_package!(package.id)
    end

    test "delete_package/1 deletes the package" do
      package = package_fixture()
      assert {:ok, %Package{}} = PackageGrids.delete_package(package)
      assert_raise Ecto.NoResultsError, fn -> PackageGrids.get_package!(package.id) end
    end

    test "change_package/1 returns a package changeset" do
      package = package_fixture()
      assert %Ecto.Changeset{} = PackageGrids.change_package(package)
    end
  end

  describe "package_in_grid" do
    setup do
      {:ok, grid} =
        PackageGrids.create_grid(%{
          name: "some grid",
          description: "some description",
          slug: "some-grid"
        })

      {:ok, package} = PackageGrids.create_package(%{name: "some package"})

      {:ok, [grid: grid, package: package]}
    end

    alias ElixirPackages.PackageGrids.PackageInGrid

    def package_in_grid_fixture(context, attrs \\ %{}) do
      {:ok, package_in_grid} =
        attrs
        |> Enum.into(%{package_id: context[:package].id, grid_id: context[:grid].id})
        |> PackageGrids.create_package_in_grid()

      package_in_grid
    end

    test "create_package_in_grid/1 with valid data creates a package_in_grid", context do
      valid_attrs = %{grid_id: context[:grid].id, package_id: context[:package].id}

      assert {:ok, %PackageInGrid{} = package_in_grid} =
               PackageGrids.create_package_in_grid(valid_attrs)
    end

    test "create_package_in_grid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               PackageGrids.create_package_in_grid(%{grid_id: 99, package_id: nil})
    end

    test "delete_package_in_grid/1 deletes the package_in_grid", context do
      package_in_grid = package_in_grid_fixture(context)
      assert {:ok, %PackageInGrid{}} = PackageGrids.delete_package_in_grid(package_in_grid)

      assert Repo.exists?(PackageInGrid) === false
    end

    test "change_package_in_grid/1 returns a package_in_grid changeset", context do
      package_in_grid = package_in_grid_fixture(context)
      assert %Ecto.Changeset{} = PackageGrids.change_package_in_grid(package_in_grid)
    end
  end
end
