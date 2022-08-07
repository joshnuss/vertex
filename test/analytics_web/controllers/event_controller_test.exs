defmodule AnalyticsWeb.Controllers.EventControllerTest do
  use AnalyticsWeb.ConnCase

  alias Analytics.Backend
  alias Analytics.Metric

  setup do
    Backend.Testing.reset!
  end

  test "POST /", %{conn: conn} do
    payload = %{
      project: "site1",
      account_id: "1234",
      event: "login.success",
      tags: ["enterprise-plan", "staging"]
    }

    conn = post(conn, "/event", payload)

    assert json_response(conn, 201) == %{}
    assert Backend.Testing.metrics == [
      %Metric{
        project: "site1",
        account_id: "1234",
        event: "login.success",
        tags: ["enterprise-plan", "staging"]
      }
    ]
  end
end
