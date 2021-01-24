defmodule ElixirPackagesWeb.Admin.GridControllerTest do
  use ElixirPackagesWeb.ConnCase

  alias ElixirPackages.PackageGrids

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:grid) do
    {:ok, grid} = PackageGrids.create_grid(@create_attrs)
    grid
  end

  describe "index" do
    test "lists all grids", %{conn: conn} do
      conn = get(conn, Routes.admin_grid_path(conn, :index))
      assert html_response(conn, 200) =~ "Grids"
    end
  end

  describe "new grid" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_grid_path(conn, :new))
      assert html_response(conn, 200) =~ "New Grid"
    end
  end

  describe "create grid" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_grid_path(conn, :create), grid: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :show, id)

      conn = get(conn, Routes.admin_grid_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Grid Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_grid_path(conn, :create), grid: @invalid_attrs
      assert html_response(conn, 200) =~ "New Grid"
    end
  end

  describe "edit grid" do
    setup [:create_grid]

    test "renders form for editing chosen grid", %{conn: conn, grid: grid} do
      conn = get(conn, Routes.admin_grid_path(conn, :edit, grid))
      assert html_response(conn, 200) =~ "Edit Grid"
    end
  end

  describe "update grid" do
    setup [:create_grid]

    test "redirects when data is valid", %{conn: conn, grid: grid} do
      conn = put conn, Routes.admin_grid_path(conn, :update, grid), grid: @update_attrs
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :show, grid)

      conn = get(conn, Routes.admin_grid_path(conn, :show, grid))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, grid: grid} do
      conn = put conn, Routes.admin_grid_path(conn, :update, grid), grid: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Grid"
    end
  end

  describe "delete grid" do
    setup [:create_grid]

    test "deletes chosen grid", %{conn: conn, grid: grid} do
      conn = delete(conn, Routes.admin_grid_path(conn, :delete, grid))
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_grid_path(conn, :show, grid))
      end
    end
  end

  defp create_grid(_) do
    grid = fixture(:grid)
    {:ok, grid: grid}
  end
end
