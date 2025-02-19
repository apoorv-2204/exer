defmodule MetaProg.C2.AssertionDemo do
  @moduledoc false
  use MetaProg.C2.Assertion

  @doc """
  defmodule MetaProg.C2.AssertionDemo do
    import MetaProg.C2.Assertion
    Module.register_attribute(MyTests, :tests, accumulate: true)
    @before_compile MetaProg.C2.Assertion
  end
  """
  test "Math test 1" do
    assert 1 == 5
    assert 2 > 0
    assert 5 < 0
  end
end
