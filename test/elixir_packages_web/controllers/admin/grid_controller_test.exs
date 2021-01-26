defmodule ElixirPackagesWeb.Admin.GridControllerTest do
  use ElixirPackagesWeb.ConnCase

  alias ElixirPackages.PackageGrids
  alias ElixirPackages.Repo
  alias ElixirPackages.Users

  @create_attrs %{description: "some description", name: "some name", slug: "some-name"}
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    slug: "some-updated-name"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:grid) do
    {:ok, grid} = PackageGrids.create_grid(@create_attrs)
    grid
  end

  describe "index" do
    setup [:login_admin]

    test "lists all grids", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.admin_grid_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Grids"
    end
  end

  describe "new grid" do
    setup [:login_admin]

    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.admin_grid_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Grid"
    end
  end

  describe "create grid" do
    setup [:login_admin]

    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post authed_conn, Routes.admin_grid_path(authed_conn, :create), grid: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :show, id)

      conn = get(authed_conn, Routes.admin_grid_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Grid Details"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post authed_conn, Routes.admin_grid_path(authed_conn, :create), grid: @invalid_attrs
      assert html_response(conn, 200) =~ "New Grid"
    end
  end

  describe "edit grid" do
    setup [:create_grid, :login_admin]

    test "renders form for editing chosen grid", %{authed_conn: authed_conn, grid: grid} do
      conn = get(authed_conn, Routes.admin_grid_path(authed_conn, :edit, grid))
      assert html_response(conn, 200) =~ "Edit Grid"
    end
  end

  describe "update grid" do
    setup [:create_grid, :login_admin]

    test "redirects when data is valid", %{authed_conn: authed_conn, grid: grid} do
      conn =
        put authed_conn, Routes.admin_grid_path(authed_conn, :update, grid), grid: @update_attrs

      grid = Repo.reload(grid)
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :show, grid)

      conn = get(authed_conn, Routes.admin_grid_path(authed_conn, :show, grid))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, grid: grid} do
      conn =
        put authed_conn, Routes.admin_grid_path(authed_conn, :update, grid), grid: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Grid"
    end
  end

  describe "delete grid" do
    setup [:create_grid, :login_admin]

    test "deletes chosen grid", %{authed_conn: authed_conn, grid: grid} do
      conn = delete(authed_conn, Routes.admin_grid_path(authed_conn, :delete, grid))
      assert redirected_to(conn) == Routes.admin_grid_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.admin_grid_path(authed_conn, :show, grid))
      end
    end
  end

  defp create_grid(_) do
    grid = fixture(:grid)
    {:ok, grid: grid}
  end

  defp login_admin(%{conn: conn}) do
    {:ok, user} = Users.create_admin(%{email: "larry@google.com"})
    opts = Pow.Plug.Session.init(otp_app: :elixir_packages)

    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :elixir_packages)

    {:ok, conn: conn, authed_conn: authed_conn}
  end
end
