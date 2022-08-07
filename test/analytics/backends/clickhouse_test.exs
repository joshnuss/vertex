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
    Bypass.expect_once(bypass, "POST", "/database=analytics&query=", fn conn ->
      {:ok, body, conn} = Conn.read_body(conn)

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

    Clickhouse.record(metric)
  end

  test "sends a metric to database with tags", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/database=analytics&query=", fn conn ->
      {:ok, body, conn} = Conn.read_body(conn)

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

    Clickhouse.record(metric)
  end
end
