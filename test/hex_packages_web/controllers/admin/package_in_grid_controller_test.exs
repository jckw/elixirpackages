defmodule HexPackagesWeb.Admin.PackageInGridControllerTest do
  use HexPackagesWeb.ConnCase

  alias HexPackages.PackageGrids

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:package_in_grid) do
    {:ok, package_in_grid} = PackageGrids.create_package_in_grid(@create_attrs)
    package_in_grid
  end

  describe "index" do
    test "lists all package_in_grid", %{conn: conn} do
      conn = get conn, Routes.admin_package_in_grid_path(conn, :index)
      assert html_response(conn, 200) =~ "Package in grid"
    end
  end

  describe "new package_in_grid" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.admin_package_in_grid_path(conn, :new)
      assert html_response(conn, 200) =~ "New Package in grid"
    end
  end

  describe "create package_in_grid" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_package_in_grid_path(conn, :create), package_in_grid: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_package_in_grid_path(conn, :show, id)

      conn = get conn, Routes.admin_package_in_grid_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Package in grid Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_package_in_grid_path(conn, :create), package_in_grid: @invalid_attrs
      assert html_response(conn, 200) =~ "New Package in grid"
    end
  end

  describe "edit package_in_grid" do
    setup [:create_package_in_grid]

    test "renders form for editing chosen package_in_grid", %{conn: conn, package_in_grid: package_in_grid} do
      conn = get conn, Routes.admin_package_in_grid_path(conn, :edit, package_in_grid)
      assert html_response(conn, 200) =~ "Edit Package in grid"
    end
  end

  describe "update package_in_grid" do
    setup [:create_package_in_grid]

    test "redirects when data is valid", %{conn: conn, package_in_grid: package_in_grid} do
      conn = put conn, Routes.admin_package_in_grid_path(conn, :update, package_in_grid), package_in_grid: @update_attrs
      assert redirected_to(conn) == Routes.admin_package_in_grid_path(conn, :show, package_in_grid)

      conn = get conn, Routes.admin_package_in_grid_path(conn, :show, package_in_grid)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, package_in_grid: package_in_grid} do
      conn = put conn, Routes.admin_package_in_grid_path(conn, :update, package_in_grid), package_in_grid: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Package in grid"
    end
  end

  describe "delete package_in_grid" do
    setup [:create_package_in_grid]

    test "deletes chosen package_in_grid", %{conn: conn, package_in_grid: package_in_grid} do
      conn = delete conn, Routes.admin_package_in_grid_path(conn, :delete, package_in_grid)
      assert redirected_to(conn) == Routes.admin_package_in_grid_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.admin_package_in_grid_path(conn, :show, package_in_grid)
      end
    end
  end

  defp create_package_in_grid(_) do
    package_in_grid = fixture(:package_in_grid)
    {:ok, package_in_grid: package_in_grid}
  end
end
