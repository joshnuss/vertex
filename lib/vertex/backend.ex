defmodule Vertex.Backend do
  alias Vertex.Metric

  @callback record(metrics :: list(Metric.t) | Metric.t) :: :ok
end
