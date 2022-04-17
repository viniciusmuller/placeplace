defmodule PlacePlace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PlacePlace.Repo,
      # Start the Telemetry supervisor
      PlacePlaceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PlacePlace.PubSub},
      # Start the Endpoint (http/https)
      PlacePlaceWeb.Endpoint
      # Start a worker by calling: PlacePlace.Worker.start_link(arg)
      # {PlacePlace.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlacePlace.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlacePlaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
