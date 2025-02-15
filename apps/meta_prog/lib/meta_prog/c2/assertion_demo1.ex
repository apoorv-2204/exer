defmodule MetaProg.C2.AssertionDemo1 do
  @moduledoc false
  import MetaProg.C2.Assertion1

  def test() do
    assert 1 == 5
    assert 2 > 0
    assert 5 < 0
  end
end
