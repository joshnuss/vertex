defmodule Analytics.Backend.Testing do
  @behaviour Analytics.Backend

  def record(metric) do
    Agent.update(:metric_log, fn state -> state ++ [metric] end)
  end

  def metrics do
    Agent.get(:metric_log, & &1)
  end

  def reset! do
    Agent.update(:metric_log, fn _state -> [] end)
  end
end
