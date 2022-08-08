defmodule VertexWeb.Controllers.EventControllerTest do
  use VertexWeb.ConnCase

  alias Plug.Conn
  alias Vertex.Backend
  alias Vertex.Metric

  setup do
    Backend.Testing.reset!()
  end

  describe "POST /event" do
    test "with valid access token", %{conn: conn} do
      payload = %{
        account_id: "1234",
        event: "login.success",
        tags: ["enterprise-plan", "staging"]
      }

      conn =
        conn
        |> Conn.put_req_header("authorization", "Bearer fake-access-token")
        |> post("/event", payload)

      assert json_response(conn, 201) == %{}

      # wait for backend to finish recording
      Process.sleep(1)

      assert Backend.Testing.metrics() == [
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
      assert Backend.Testing.metrics() == []
    end

    test "with invalid access token", %{conn: conn} do
      conn =
        conn
        |> Conn.put_req_header("authorization", "Bearer invalid-access-token")
        |> post("/event", %{})

      assert json_response(conn, 401) == %{"message" => "invalid access token"}
      assert Backend.Testing.metrics() == []
    end
  end

  describe "POST /events" do
    test "with valid access token", %{conn: conn} do
      payload = Jason.encode!([
        %{
          account_id: "1234",
          event: "login.success",
          tags: ["plan:enterprise", "staging"]
        },
        %{
          account_id: "1234",
          event: "login.failure",
          tags: ["plan:enterprise", "staging"]
        }
      ])

      conn =
        conn
        |> Conn.put_req_header("authorization", "Bearer fake-access-token")
        |> Conn.put_req_header("content-type", "application/json")
        |> post("/events", payload)

      assert json_response(conn, 201) == %{}

      # wait for backend to finish recording
      Process.sleep(1)

      assert Backend.Testing.metrics() == [
               %Metric{
                 project: "site1",
                 account_id: "1234",
                 event: "login.success",
                 tags: ["plan:enterprise", "staging"]
               },
               %Metric{
                 project: "site1",
                 account_id: "1234",
                 event: "login.failure",
                 tags: ["plan:enterprise", "staging"]
               }
             ]
    end

    test "without access token", %{conn: conn} do
      conn = post(conn, "/events", [])

      assert json_response(conn, 401) == %{"message" => "invalid access token"}
      assert Backend.Testing.metrics() == []
    end

    test "with invalid access token", %{conn: conn} do
      conn =
        conn
        |> Conn.put_req_header("authorization", "Bearer invalid-access-token")
        |> post("/events", [])

      assert json_response(conn, 401) == %{"message" => "invalid access token"}
      assert Backend.Testing.metrics() == []
    end
  end
end
