defmodule Vertex.Backend.Logger do
  @behaviour Vertex.Backend

  def record(metrics) when is_list(metrics) do
    Enum.each(metrics, &record/1)
  end

  def record(metric) do
    metric
    |> Map.from_struct()
    |> Jason.encode!()
    |> IO.puts()
  end
end
