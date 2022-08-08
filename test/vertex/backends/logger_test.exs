defmodule Vertex.Backend.LoggerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Vertex.Metric
  alias Vertex.Backend.Logger

  test "sends a metric to stdout" do
    metric = %Metric{
      project: "example",
      tenant: "123",
      event: "login.success",
      tags: ["test", "staging"]
    }

    assert capture_io(fn ->
             :ok = Logger.record(metric)
           end) ==
             ~s|{"event":"login.success","project":"example","tags":["test","staging"],"tenant":"123"}\n|
  end

  test "sends multiple metrics to stdout" do
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

    assert capture_io(fn ->
             :ok = Logger.record([one, two])
    end) == """
    {"event":"login.success","project":"example","tags":["test"],"tenant":"123"}
    {"event":"login.failure","project":"foo","tags":["test"],"tenant":"123"}
    """
  end
end
