defmodule AnalyticsWeb.EventController do
  use AnalyticsWeb, :controller

  alias Analytics.Metric

  @backend Application.get_env(:analytics, :backend)

  def create(conn, params) do
    metric = %Metric{
      project: params["project"],
      account_id: params["account_id"],
      event: params["event"],
      tags: params["tags"]
    }

    @backend.record(metric)

    conn
    |> put_status(:created)
    |> json(%{})
  end
end
