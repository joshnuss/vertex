defmodule Vertex.Metric do
  @enforce_keys [:project, :event]
  defstruct project: nil,
            account_id: nil,
            event: nil,
            tags: []
end
