defmodule HexPackagesWeb.Admins.PackageControllerTest do
  use HexPackagesWeb.ConnCase

  alias HexPackages.PackageGrids

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:package) do
    {:ok, package} = PackageGrids.create_package(@create_attrs)
    package
  end

  describe "index" do
    test "lists all package", %{conn: conn} do
      conn = get conn, Routes.admins_package_path(conn, :index)
      assert html_response(conn, 200) =~ "Package"
    end
  end

  describe "new package" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.admins_package_path(conn, :new)
      assert html_response(conn, 200) =~ "New Package"
    end
  end

  describe "create package" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admins_package_path(conn, :create), package: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admins_package_path(conn, :show, id)

      conn = get conn, Routes.admins_package_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Package Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admins_package_path(conn, :create), package: @invalid_attrs
      assert html_response(conn, 200) =~ "New Package"
    end
  end

  describe "edit package" do
    setup [:create_package]

    test "renders form for editing chosen package", %{conn: conn, package: package} do
      conn = get conn, Routes.admins_package_path(conn, :edit, package)
      assert html_response(conn, 200) =~ "Edit Package"
    end
  end

  describe "update package" do
    setup [:create_package]

    test "redirects when data is valid", %{conn: conn, package: package} do
      conn = put conn, Routes.admins_package_path(conn, :update, package), package: @update_attrs
      assert redirected_to(conn) == Routes.admins_package_path(conn, :show, package)

      conn = get conn, Routes.admins_package_path(conn, :show, package)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, package: package} do
      conn = put conn, Routes.admins_package_path(conn, :update, package), package: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Package"
    end
  end

  describe "delete package" do
    setup [:create_package]

    test "deletes chosen package", %{conn: conn, package: package} do
      conn = delete conn, Routes.admins_package_path(conn, :delete, package)
      assert redirected_to(conn) == Routes.admins_package_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.admins_package_path(conn, :show, package)
      end
    end
  end

  defp create_package(_) do
    package = fixture(:package)
    {:ok, package: package}
  end
end
