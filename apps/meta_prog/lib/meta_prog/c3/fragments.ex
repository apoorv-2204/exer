defmodule MetaProg.C3.Fragments do
  Enum.map([one: 1, two: 2, three: 3], fn {n, v} ->
    def unquote(n)(), do: unquote(v)
  end)

  #   With unquote fragments, we can pass any valid atom to def and dynamically
  # define a function with that name. We’ll use unquote fragments heavily
  # throughout the rest of this chapter
end
