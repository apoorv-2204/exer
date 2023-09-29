defmodule Issues.GithubIssues do
  @moduledoc """
  ad
  """
  @user_agent [{"User-agent", "elixir work"}]
  @base_url Application.get_env(:issues, :github_url)

  def fetch_issues() do
    fetch_issues("user", "project", "_count")
  end

  def fetch_issues(user, project, _count) do
    url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def url(_user, _project) do
    user = "elixir-lang"
    project = "elixir"
    "#{@base_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {status_code |> check_for_error(), body |> Poison.Parser.parse!()}
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
