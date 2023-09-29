defmodule Issues.TableFormatterTest do
  @moduledoc false
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: Taf

  @simple_test_data [
    [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
    [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
  ]

  @headers [:c1, :c2, :c4]

  test "split_into_columns" do
    columns = split_with_three_columns()
    assert length(columns) == length(@headers)
    assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
    assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "column_widths" do
    widths = Taf.widths_of(split_with_three_columns())
    assert widths == [5, 6, 7]
  end

  test "correct format string returned" do
    assert Taf.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "Output is correct" do
    result =
      capture_io(fn ->
        Taf.print_table_for_cols(@simple_test_data, @headers)
      end)

    assert result == """
           c1    | c2     | c4\s \s \s
           ------+--------+--------
           r1 c1 | r1 c2  | r1+++c4
           r2 c1 | r2 c2  | r2 c4 \s
           r3 c1 | r3 c2  | r3 c4 \s
           r4 c1 | r4++c2 | r4 c4 \s
           """
  end

  def split_with_three_columns() do
    Taf.split_into_columns(@simple_test_data, @headers)
  end
end
