defmodule Analytics.Backend do
  @callback record(metric :: Analytics.Metric.t) :: any
end
