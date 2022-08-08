defmodule Vertex.Backend.LoggerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Vertex.Metric
  alias Vertex.Backend.Logger

  test "sends a metric to stdout" do
    metric = %Metric{
      project: "example",
      account_id: "123",
      event: "login.success",
      tags: ["test", "staging"]
    }

    assert capture_io(fn ->
             :ok = Logger.record(metric)
           end) ==
             ~s|{"account_id":"123","event":"login.success","project":"example","tags":["test","staging"]}\n|
  end

  test "sends multiple metrics to stdout" do
    one = %Metric{
      project: "example",
      account_id: "123",
      event: "login.success",
      tags: ["test"]
    }

    two = %Metric{
      project: "foo",
      account_id: "123",
      event: "login.failure",
      tags: ["test"]
    }

    assert capture_io(fn ->
             :ok = Logger.record([one, two])
    end) == """
    {"account_id":"123","event":"login.success","project":"example","tags":["test"]}
    {"account_id":"123","event":"login.failure","project":"foo","tags":["test"]}
    """
  end
end
