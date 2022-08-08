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

  test "logs multiple metric" do
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

    assert Testing.record([one, two]) == :ok
    assert Testing.metrics() == [one, two]
  end
end
