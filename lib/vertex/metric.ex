defmodule Vertex.Metric do
  @enforce_keys [:project, :event]
  defstruct project: nil,
            tenant: nil,
            event: nil,
            tags: []
end
