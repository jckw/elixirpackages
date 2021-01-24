defmodule ElixirPackagesWeb.Admin.PackageController do
  use ElixirPackagesWeb, :controller

  alias ElixirPackages.PackageGrids
  alias ElixirPackages.PackageGrids.Package

  plug(:put_layout, "torch.html")

  def index(conn, params) do
    case PackageGrids.paginate_packages(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Packages. #{inspect(error)}")
        |> redirect(to: Routes.admin_package_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = PackageGrids.change_package(%Package{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"package" => package_params}) do
    case PackageGrids.create_package(package_params) do
      {:ok, package} ->
        conn
        |> put_flash(:info, "Package created successfully.")
        |> redirect(to: Routes.admin_package_path(conn, :show, package))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    package = PackageGrids.get_package!(id)
    render(conn, "show.html", package: package)
  end

  def edit(conn, %{"id" => id}) do
    package = PackageGrids.get_package!(id)
    changeset = PackageGrids.change_package(package)
    render(conn, "edit.html", package: package, changeset: changeset)
  end

  def update(conn, %{"id" => id, "package" => package_params}) do
    package = PackageGrids.get_package!(id)

    case PackageGrids.update_package(package, package_params) do
      {:ok, package} ->
        conn
        |> put_flash(:info, "Package updated successfully.")
        |> redirect(to: Routes.admin_package_path(conn, :show, package))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", package: package, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    package = PackageGrids.get_package!(id)
    {:ok, _package} = PackageGrids.delete_package(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: Routes.admin_package_path(conn, :index))
  end
end
