defmodule AnalyticsWeb.Controllers.EventControllerTest do
  use AnalyticsWeb.ConnCase

  alias Plug.Conn
  alias Analytics.Backend
  alias Analytics.Metric

  setup do
    Backend.Testing.reset!
  end

  describe "POST /" do

    test "with valid access token", %{conn: conn} do
      payload = %{
        project: "site1",
        account_id: "1234",
        event: "login.success",
        tags: ["enterprise-plan", "staging"]
      }

      conn = conn
      |> Conn.put_req_header("authorization", "Bearer fake-access-token")
      |> post("/event", payload)

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

    test "without access token", %{conn: conn} do
      conn = post(conn, "/event", %{})

      assert json_response(conn, 401) == %{"message" => "invalid access token"}
      assert Backend.Testing.metrics == []
    end

    test "with invalid access token", %{conn: conn} do
      conn = conn
      |> Conn.put_req_header("authorization", "Bearer invalid-access-token")
      |> post("/event", %{})

      assert json_response(conn, 401) == %{"message" => "invalid access token"}
      assert Backend.Testing.metrics == []
    end
  end
end
