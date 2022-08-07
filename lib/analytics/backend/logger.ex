defmodule Analytics.Backend.Logger do
  @behaviour Analytics.Backend

  def record(metric) do
    metric
    |> Map.from_struct()
    |> Jason.encode!()
    |> IO.puts()
  end
end
