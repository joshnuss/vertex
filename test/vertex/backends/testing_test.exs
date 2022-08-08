defmodule Vertex.Backend.TestingTest do
  use ExUnit.Case

  alias Vertex.Metric
  alias Vertex.Backend.Testing

  setup do
    Testing.reset!()
  end

  test "logs a metric" do
    metric = %Metric{
      project: "example",
      account_id: "123",
      event: "access.login.success",
      tags: ["test", "staging"]
    }

    assert Testing.record(metric) == :ok
    assert Testing.metrics() == [metric]
  end
end
