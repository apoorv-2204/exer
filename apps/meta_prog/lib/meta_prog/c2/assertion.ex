defmodule MetaProg.C2.Assertion do
  @moduledoc false
  defmacro __using__ do
    quote do
      IO.inspect(unquote(__MODULE__))
    end
  end
end

defmodule MetaProg.C2.Assertion.Test do
  def log_dot(), do: IO.puts(".")

  def assert(:==, lhs, rhs) when Kernel.==(lhs, rhs) do
    log_dot()
  end

  def assert(:==, lhs, rhs) do
    IO.puts("{:==, false}")
  end

  def assert(:>, lhs, rhs) when Kernel.>(lhs, rhs) do
    log_dot()
  end

  def assert(:>, lhs, rhs) do
    IO.puts("{:>, false}")
  end

  def assert(:<, lhs, rhs) when Kernel.<(lhs, rhs) do
    log_dot()
  end

  def assert(:<, lhs, rhs) do
    IO.puts("{:<, false}")
  end
end
