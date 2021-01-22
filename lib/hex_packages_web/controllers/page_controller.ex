defmodule HexPackagesWeb.PageController do
  use HexPackagesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
