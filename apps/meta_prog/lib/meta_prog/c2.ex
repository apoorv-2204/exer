defmodule MetaProg.C2 do
  @moduledoc """
  macros allow you to effectively create your own keywords in
  the language,
  """
  alias MetaProg.C2.ControlFlow2
  require ControlFlow2

  @doc """

   iex> control_flow2_demo()
   "correct"
  """
  def control_flow2_demo() do
    ControlFlow2.my_if 1 == 1 do
      "correct"
    else
      "incorrect"
    end
  end

  alias MetaProg.C2.Loops
  require Loops

  def loop_demo() do
    spawn(fn ->
      Loops.while Process.alive?(self()) do
        IO.puts("ping")
        :timer.sleep(1000)

        send(self(), :ping)
        IO.puts("\n")

        receive do
          :ping ->
            IO.puts("pong")
            :timer.sleep(1000)
        end
      end
    end)
  end

  def loop_demo1() do
    spawn(fn ->
      Loops.while true do
        receive do
          :stop ->
            IO.puts("Stopping...")
            Loops.break()

          message ->
            IO.puts("Got new #{message}")
        end
      end
    end)
  end

  import MetaProg.C2.Debugger

  def debug_demo() do
    Application.put_env(:debugger, :log_level, :debug)
    log(:hello)
  end
end
