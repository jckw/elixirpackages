defmodule ElixirPackagesWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias ElixirPackagesWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_out_path(conn), do: Routes.page_path(conn, :index)
end
