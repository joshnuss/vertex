defmodule Analytics.Backend.ClickhouseTest do
  use ExUnit.Case

  alias Plug.Conn
  alias Analytics.Metric
  alias Analytics.Backend.Clickhouse

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
             INSERT INTO metrics (project, account_id, event, tags)
             VALUES (
               'example',
               '123',
               'access.login.success',
               []
             )
             """

      Conn.resp(conn, 200, "")
    end)

    metric = %Metric{
      project: "example",
      account_id: "123",
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
             INSERT INTO metrics (project, account_id, event, tags)
             VALUES (
               'example',
               '123',
               'access.login.success',
               ['test','staging']
             )
             """

      Conn.resp(conn, 200, "")
    end)

    metric = %Metric{
      project: "example",
      account_id: "123",
      event: "access.login.success",
      tags: ["test", "staging"]
    }

    assert Clickhouse.record(metric) == :ok
  end
end
