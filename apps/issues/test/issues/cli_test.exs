defmodule Issues.CLITest do
  use ExUnit.Case, async: true
  doctest Issues.CLI

  import Issues.CLI, only: [parse_args: 1, sort_into_desc_order: 1]

  test "check sort in desc order " do
    desc_issues = sort_into_desc_order(create_list())
    vals = for issue <- desc_issues, do: Map.get(issue, "created_at")
    assert vals == ~w(e d c b a)
  end

  def create_list() do
    values = ["a", "b", "c", "e", "d"]

    for val <- values,
        do: %{"created_at" => val, "rnd" => "random_data"}
  end

  test "parse_args/1 :help return by option parser with options -h --help" do
    # list of argv delimited by space
    assert parse_args(["-h", "anythingelse"]) == :help
    assert parse_args(["--help", "sasageyo"]) == :help
  end

  test "three values returned if three values given" do
    assert parse_args(["eren", "jaeger", "5"]) == {"eren", "jaeger", 5}
  end

  test "three values returned if two values given " do
    assert parse_args(["armin"]) == :help
    # if key value paur then only it consider as that keyword list
    # argument was given
    assert parse_args(["hangi", "levi"]) == {"hangi", "levi", 3}
  end
end
