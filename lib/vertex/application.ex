defmodule Vertex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Vertex.Project,
      # Start the Telemetry supervisor
      VertexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vertex.PubSub},
      # Start the Endpoint (http/https)
      VertexWeb.Endpoint
      # Start a worker by calling: Vertex.Worker.start_link(arg)
      # {Vertex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vertex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VertexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
