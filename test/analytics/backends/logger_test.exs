defmodule Analytics.Backend.LoggerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Analytics.Metric
  alias Analytics.Backend.Logger

  test "sends a metric to database" do
    metric = %Metric{
      project: "example",
      account_id: "123",
      event: "access.login.success",
      tags: ["test", "staging"]
    }

    assert capture_io(fn ->
      Logger.record(metric)
    end) == ~s|{"account_id":"123","event":"access.login.success","project":"example","tags":["test","staging"]}\n|
  end
end
