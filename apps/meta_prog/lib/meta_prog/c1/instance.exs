defmodule MetaProg.C1.Instance do
  @moduledoc false
  require Logger

  defmodule Notifier do
    def ping(pid) do
      if Process.alive?(pid) do
        Logger.debug("Sending ping!")
        send(pid, :ping)
      end
    end
  end
end
