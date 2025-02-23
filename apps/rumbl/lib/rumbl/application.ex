defmodule Rumbl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # children = [
    #   # Start the Telemetry supervisor
    #   RumblWeb.Telemetry,
    #   # Start the Ecto repository
    #   Rumbl.Repo,
    #   # Start the PubSub system
    #   {Phoenix.PubSub, name: Rumbl.PubSub},
    #   # Start Finch
    #   {Finch, name: Rumbl.Finch},
    #   # Start the Endpoint (http/https)
    #   RumblWeb.Endpoint
    #   # Start a worker by calling: Rumbl.Worker.start_link(arg)
    #   # {Rumbl.Worker, arg}
    # ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rumbl.Supervisor]
    Supervisor.start_link([], opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RumblWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
