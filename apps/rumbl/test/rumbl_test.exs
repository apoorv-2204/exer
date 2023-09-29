defmodule RumblTest do
  use ExUnit.Case
  doctest Rumbl

  test "greets the world" do
    assert Rumbl.hello() == :world
  end
end
