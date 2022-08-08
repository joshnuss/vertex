defmodule VertexWeb.EventController do
  use VertexWeb, :controller

  alias Vertex.Metric

  @backend Application.get_env(:vertex, :backend)

  def create(conn, params) do
    metric = %Metric{
      project: conn.assigns.project,
      account_id: params["account_id"],
      event: params["event"],
      tags: params["tags"]
    }

    spawn(fn ->
      @backend.record(metric)
    end)

    conn
    |> put_status(:created)
    |> json(%{})
  end
end
