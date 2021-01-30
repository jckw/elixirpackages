defmodule ElixirPackages.PackageGrids.SyncPackageData do
  use GenServer

  alias ElixirPackages.PackageGrids

  @github_access_token Application.get_env(:elixir_packages, :github_access_token)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    for package <- PackageGrids.list_packages() do
      sync_package_data(package)

      # Don't exceed GitHub's rate limit
      Process.sleep(750)
    end

    schedule_work()
    {:noreply, state}
  end

  def schedule_work() do
    # every 6 hours
    Process.send_after(self(), :work, 6 * 60 * 60 * 1000)
  end

  @spec get_json(String.t()) :: {:ok, map} | {:error, term()}
  def get_json(url) do
    HTTPoison.get(url)
    |> case do
      {:ok, response} ->
        Map.get(response, :body)
        |> Jason.decode()

      x ->
        x
    end
  end

  @spec fetch_hex_data(String.t()) :: {:ok, map} | {:error, term()}
  def fetch_hex_data(name) do
    get_json("https://hex.pm/api/packages/" <> name)
    |> case do
      {:ok,
       %{
         "html_url" => hex_url,
         "latest_stable_version" => latest_stable_version,
         "latest_version" => latest_version,
         "meta" => %{
           "description" => description,
           "links" => links
         },
         "releases" => [%{"inserted_at" => last_released} | _]
       }} ->
        {:ok,
         %{
           name: name,
           hex_url: hex_url,
           latest_stable_version: latest_stable_version,
           latest_version: latest_version,
           description: description,
           last_released: last_released,
           links: links
         }}

      {:ok, _} ->
        {:error, "Missing data"}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec build_package_data(String.t()) :: map()
  def build_package_data(name) do
    fetch_hex_data(name)
    |> case do
      {:ok, hex_data} -> Map.merge(hex_data, get_repo_data_from_links(hex_data.links))
      _ -> %{}
    end
  end

  @spec fetch_github_data(String.t()) :: map()
  def fetch_github_data(github_url) do
    "https://github.com/" <> user_repo = github_url
    [owner, repo] = String.split(user_repo, "/")

    Tentacat.Client.new(%{access_token: @github_access_token})
    |> Tentacat.Repositories.repo_get(owner, repo)
    |> case do
      {200, data, _} ->
        %{
          stars_count: data["stargazers_count"],
          forks_count: data["forks_count"],
          issues_count: data["open_issues"]
        }

      _ ->
        %{}
    end
    |> Map.merge(%{repo_provider: "GitHub", repo_url: github_url})
  end

  @spec get_repo_data_from_links(map()) :: map()
  def get_repo_data_from_links(%{"github" => url}), do: fetch_github_data(url)
  def get_repo_data_from_links(%{"GitHub" => url}), do: fetch_github_data(url)
  def get_repo_data_from_links(%{"Github" => url}), do: fetch_github_data(url)
  def get_repo_data_from_links(_), do: %{}

  @spec sync_package_data(%PackageGrids.Package{name: String.t()}) ::
          {:ok, %PackageGrids.Package{}} | {:error, %Ecto.Changeset{}}
  def sync_package_data(package) do
    PackageGrids.update_package(package, build_package_data(package.name))
  end
end
