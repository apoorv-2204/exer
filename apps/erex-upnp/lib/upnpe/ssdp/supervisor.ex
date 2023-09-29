defmodule SSDP.Supervisor do
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    # children = [
    #   supervisor(Registry, [:duplicate, SSDP.Registry, []]),
    #   supervisor(Task.Supervisor, name: SSDP.TaskSupervisor),
    #   worker(SSDP.Client, [])
    # ]

    # supervise(children, strategy: :one_for_one)

    children = [{SSDP.Client, []}]
  end
end
