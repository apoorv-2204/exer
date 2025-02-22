defmodule MetaProg.C2.AssertionDemo do
  @moduledoc false
  use MetaProg.C2.Assertion

  # @doc """
  # defmodule MetaProg.C2.AssertionDemo do
  #   import MetaProg.C2.Assertion
  #   Module.register_attribute(MyTests, :tests, accumulate: true)
  #   @before_compile MetaProg.C2.Assertion
  # end
  # """
  test "Math test 1" do
    assert 1 == 5
    assert 5 === "5"
    assert 5 == 5
    assert 2 > 0
    assert 5 < 0
  end

  test "integers can be added and subtracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end

  test "integers can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end

  test "refute of about " do
    refute 6 * 6 == 36
  end
end
