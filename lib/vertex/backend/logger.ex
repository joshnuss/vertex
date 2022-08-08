defmodule Vertex.Backend.Logger do
  @behaviour Vertex.Backend

  def record(metric) do
    metric
    |> Map.from_struct()
    |> Jason.encode!()
    |> IO.puts()
  end
end
