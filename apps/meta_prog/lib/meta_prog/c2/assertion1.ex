defmodule MetaProg.C2.Assertion1 do
  @moduledoc false

  defmacro assert({operator, context, [lhs, rhs]}) do
    quote bind_quoted: [op: operator, ctx: context, lhs: lhs, rhs: rhs] do
      MetaProg.C2.Assertion.Test.assert(op, lhs, rhs)
    end
  end
end
