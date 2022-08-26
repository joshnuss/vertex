defmodule VertexWeb.EventController do
  use VertexWeb, :controller

  alias Vertex.Metric

  def create(conn, params) do
    metric = %Metric{
      project: conn.assigns.project,
      tenant: params["tenant"],
      event: params["event"],
      tags: params["tags"] || []
    }

    spawn_record(metric)

    conn
    |> put_status(:created)
    |> json(%{})
  end

  def batch(conn, params) do
    list = params["_json"]
    metrics = Enum.map(list, & %Metric{
      project: conn.assigns.project,
      tenant: &1["tenant"],
      event: &1["event"],
      tags: &1["tags"] || []
    })

    spawn_record(metrics)

    conn
    |> put_status(:created)
    |> json(%{})
  end

  defp spawn_record(metrics) do
    backend = Application.get_env(:vertex, :backend)

    spawn(fn ->
      backend.record(metrics)
    end)
  end
end
