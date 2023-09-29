defmodule Issues.CLI do
  @moduledoc """
  Handling the command line parsing and dispatch to
  the various functions that end up generating a
  table of the last _N_  issues in a github project
  """
  @default_count 3

  alias Issues.TableFormatter

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def process(:help) do
    IO.puts("""
    Usage: <username> <project> <count>default: #{@default_count}
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch_issues(user, project, count)
    |> decode_response()
    |> sort_into_desc_order()
    |> latest_issues(count)
    |> TableFormatter.print_table_for_cols(["number", "created_at", "title"])
  end

  def latest_issues(list, count) do
    list |> Enum.take(count) |> Enum.reverse()
  end

  def sort_into_desc_order(list_of_issues) do
    Enum.sort(list_of_issues, fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts(error)
    System.halt(2)
  end

  @doc """
  argv can be [-h or --help, which returns :help]
  And {github username, project, size(optionall default to 10) }
  Return a tuple of `{username, project, size}`, or `:help`
  if help was given

  two red flags
  conditonal logic
  and too long
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> args_to_internal_representation()
  end

  def args_to_internal_representation({[help: true], [], []}) do
    :help
  end

  def args_to_internal_representation({_, [user, project, count], _}) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation({_, [user, project], _}) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end
end
