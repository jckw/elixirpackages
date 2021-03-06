defmodule ElixirPackagesWeb.GridController do
  use ElixirPackagesWeb, :controller
  alias ElixirPackages.{PackageGrids, Repo}

  def show(conn, %{"id" => slug}) do
    grid = Repo.preload(PackageGrids.get_grid_by_slug!(slug), :packages)
    render(conn, "show.html", grid: grid)
  end
end
