defmodule Analytics.Backend do
  @callback record(metric :: Analytics.Metric.t()) :: :ok
end
