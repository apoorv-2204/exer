defmodule MetaProg.C2.Debugger do
  @moduledoc false

  defmacro log(expression) do
    case Application.get_env(:debugger, :log_level) === :debug do
      x when x in [nil, false] ->
        expression

      true ->
        quote bind_quoted: [expr: expression] do
          IO.inspect("===================")
          IO.inspect(expr)
          IO.inspect("===================")
          nil
        end
    end
  end
end
