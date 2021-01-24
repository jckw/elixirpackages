defmodule ElixirPackagesWeb.PageController do
  use ElixirPackagesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
