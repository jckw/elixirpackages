defmodule ElixirPackagesWeb.Admin.PackageControllerTest do
  use ElixirPackagesWeb.ConnCase

  alias ElixirPackages.PackageGrids
  alias ElixirPackages.Users

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:package) do
    {:ok, package} = PackageGrids.create_package(@create_attrs)
    package
  end

  describe "index" do
    setup [:login_admin]

    test "lists all packages", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.admin_package_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Packages"
    end
  end

  describe "new package" do
    setup [:login_admin]

    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.admin_package_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Package"
    end
  end

  describe "create package" do
    setup [:login_admin]

    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn =
        post authed_conn, Routes.admin_package_path(authed_conn, :create), package: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_package_path(conn, :show, id)

      conn = get(authed_conn, Routes.admin_package_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Package Details"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn =
        post authed_conn, Routes.admin_package_path(authed_conn, :create), package: @invalid_attrs

      assert html_response(conn, 200) =~ "New Package"
    end
  end

  describe "edit package" do
    setup [:create_package, :login_admin]

    test "renders form for editing chosen package", %{authed_conn: authed_conn, package: package} do
      conn = get(authed_conn, Routes.admin_package_path(authed_conn, :edit, package))
      assert html_response(conn, 200) =~ "Edit Package"
    end
  end

  describe "update package" do
    setup [:create_package, :login_admin]

    test "redirects when data is valid", %{authed_conn: authed_conn, package: package} do
      conn =
        put authed_conn, Routes.admin_package_path(authed_conn, :update, package),
          package: @update_attrs

      assert redirected_to(conn) == Routes.admin_package_path(conn, :show, package)

      conn = get(authed_conn, Routes.admin_package_path(authed_conn, :show, package))

      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, package: package} do
      conn =
        put authed_conn, Routes.admin_package_path(authed_conn, :update, package),
          package: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Package"
    end
  end

  describe "delete package" do
    setup [:create_package, :login_admin]

    test "deletes chosen package", %{authed_conn: authed_conn, package: package} do
      conn = delete(authed_conn, Routes.admin_package_path(authed_conn, :delete, package))
      assert redirected_to(conn) == Routes.admin_package_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.admin_package_path(authed_conn, :show, package))
      end
    end
  end

  defp create_package(_) do
    package = fixture(:package)
    {:ok, package: package}
  end

  defp login_admin(%{conn: conn}) do
    {:ok, user} = Users.create_admin(%{email: "larry@google.com"})
    opts = Pow.Plug.Session.init(otp_app: :elixir_packages)

    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :elixir_packages)

    {:ok, conn: conn, authed_conn: authed_conn}
  end
end
