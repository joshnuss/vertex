defmodule Vertex.Backend.ClickhouseTest do
  use ExUnit.Case

  alias Plug.Conn
  alias Vertex.Metric
  alias Vertex.Backend.Clickhouse

  setup do
    bypass = Bypass.open(port: 6001)

    %{bypass: bypass}
  end

  test "sends a metric to database", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      {:ok, body, conn} = Conn.read_body(conn)

      assert conn.query_params["database"] == "analytics"
      assert conn.query_params["query"] == ""

      assert body == """
             INSERT INTO metrics (project, tenant, event, tags)
             FORMAT Values ('example', '123', 'access.login.success', [])
             """

      Conn.resp(conn, 200, "")
    end)

    metric = %Metric{
      project: "example",
      tenant: "123",
      event: "access.login.success"
    }

    assert Clickhouse.record(metric) == :ok
  end

  test "sends a metric to database with tags", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      {:ok, body, conn} = Conn.read_body(conn)

      assert conn.query_params["database"] == "analytics"
      assert conn.query_params["query"] == ""

      assert body == """
             INSERT INTO metrics (project, tenant, event, tags)
             FORMAT Values ('example', '123', 'access.login.success', ['test','staging'])
             """

      Conn.resp(conn, 200, "")
    end)

    metric = %Metric{
      project: "example",
      tenant: "123",
      event: "access.login.success",
      tags: ["test", "staging"]
    }

    assert Clickhouse.record(metric) == :ok
  end

  test "sends multiple metrics", %{ bypass: bypass } do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      {:ok, body, conn} = Conn.read_body(conn)

      assert conn.query_params["database"] == "analytics"
      assert conn.query_params["query"] == ""

      assert body == """
             INSERT INTO metrics (project, tenant, event, tags)
             FORMAT Values ('example', '123', 'login.success', ['test']),
             ('foo', '123', 'login.failure', ['test'])
             """

      Conn.resp(conn, 200, "")
    end)

    one = %Metric{
      project: "example",
      tenant: "123",
      event: "login.success",
      tags: ["test"]
    }

    two = %Metric{
      project: "foo",
      tenant: "123",
      event: "login.failure",
      tags: ["test"]
    }


    assert Clickhouse.record([one, two]) == :ok
  end
end
