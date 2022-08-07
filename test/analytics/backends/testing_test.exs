defmodule Analytics.Backend.TestingTest do
  use ExUnit.Case

  alias Analytics.Metric
  alias Analytics.Backend.Testing

  test "logs a metric" do
    metric = %Metric{
      project: "example",
      account_id: "123",
      event: "access.login.success",
      tags: ["test", "staging"]
    }

    Testing.record(metric)

    assert Testing.metrics == [metric]
  end
end
