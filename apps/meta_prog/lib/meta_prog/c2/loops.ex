defmodule MetaProg.C2.Loops do
  @moduledoc """

  """
  alias __MODULE__

  defmacro while(expr, do: do_block) do
    quote do
      try do
        for :ok <- Stream.cycle([:ok]) do
          case unquote(expr) do
            x when x in [false, nil] ->
              Loops.break()

            _ ->
              unquote(do_block)
          end
        end
      catch
        :break ->
          :ok
      end
    end
  end

  def break(), do: throw(:break)
end
