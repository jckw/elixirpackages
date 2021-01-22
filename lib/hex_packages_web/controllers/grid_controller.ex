defmodule HexPackagesWeb.GridController do
  use HexPackagesWeb, :controller
  alias HexPackages.Repo
  alias HexPackages.Grid

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    grid = Repo.get(Grid, id)
    render(conn, "show.html", grid: grid)
  end
end
