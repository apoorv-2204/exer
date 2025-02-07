defmodule UPNPE.Application do
  @moduledoc false

  use Application

  # alias UPNPE.SSDP.Supervisor, as: SSDPSupervisor

  def start(_type, _args) do
    # children = [{SSDPSupervisor, []}]
    children = []

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: UPNPE.Supervisor
    )
  end
end
