defmodule VertexWeb.EventController do
  use VertexWeb, :controller

  alias Vertex.Metric

  @backend Application.get_env(:vertex, :backend)

  def create(conn, params) do
    metric = %Metric{
      project: conn.assigns.project,
      account_id: params["account_id"],
      event: params["event"],
      tags: params["tags"] || []
    }

    spawn(fn ->
      @backend.record(metric)
    end)

    conn
    |> put_status(:created)
    |> json(%{})
  end

  def batch(conn, params) do
    list = params["_json"]
    metrics = Enum.map(list, & %Metric{
      project: conn.assigns.project,
      account_id: &1["account_id"],
      event: &1["event"],
      tags: &1["tags"] || []
    })

    spawn(fn ->
      @backend.record(metrics)
    end)

    conn
    |> put_status(:created)
    |> json(%{})
  end
end
