defmodule ElixirPackagesWeb.Admin.GridController do
  use ElixirPackagesWeb, :controller

  alias ElixirPackages.Repo
  alias ElixirPackages.PackageGrids
  alias ElixirPackages.PackageGrids.{Grid, PackageInGrid}

  plug(:put_layout, "torch.html")

  def index(conn, params) do
    case PackageGrids.paginate_grids(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Grids. #{inspect(error)}")
        |> redirect(to: Routes.admin_grid_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = PackageGrids.change_grid(%Grid{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"grid" => grid_params}) do
    case PackageGrids.create_grid(grid_params) do
      {:ok, grid} ->
        conn
        |> put_flash(:info, "Grid created successfully.")
        |> redirect(to: Routes.admin_grid_path(conn, :show, grid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    grid = Repo.preload(PackageGrids.get_grid_by_slug!(id), :packages)
    render(conn, "show.html", grid: grid)
  end

  def edit(conn, %{"id" => id}) do
    grid = PackageGrids.get_grid_by_slug!(id)
    changeset = PackageGrids.change_grid(grid)
    render(conn, "edit.html", grid: grid, changeset: changeset)
  end

  def update(conn, %{"id" => id, "grid" => grid_params}) do
    grid = PackageGrids.get_grid_by_slug!(id)

    case PackageGrids.update_grid(grid, grid_params) do
      {:ok, grid} ->
        conn
        |> put_flash(:info, "Grid updated successfully.")
        |> redirect(to: Routes.admin_grid_path(conn, :show, grid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", grid: grid, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    grid = PackageGrids.get_grid_by_slug!(id)
    {:ok, _grid} = PackageGrids.delete_grid(grid)

    conn
    |> put_flash(:info, "Grid deleted successfully.")
    |> redirect(to: Routes.admin_grid_path(conn, :index))
  end

  def add_package(conn, %{"grid_id" => id}) do
    grid = PackageGrids.get_grid_by_slug!(id)
    changeset = PackageGrids.change_package_in_grid(%PackageInGrid{grid_id: id})
    packages = PackageGrids.list_packages() |> Enum.map(&{&1.name, &1.id})
    render(conn, "add_package.html", grid: grid, changeset: changeset, packages: packages)
  end

  def save_package(conn, %{"grid_id" => id, "package_in_grid" => %{"package_id" => package_id}}) do
    grid = PackageGrids.get_grid_by_slug!(id)

    case PackageGrids.create_package_in_grid(%{package_id: package_id, grid_id: grid.id}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Package added to grid")
        |> redirect(to: Routes.admin_grid_path(conn, :show, grid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "add_package.html", changeset: changeset)
    end
  end
end
