defmodule Vertex.Backend do
  @callback record(metric :: Vertex.Metric.t()) :: :ok
end
