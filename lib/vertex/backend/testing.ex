defmodule Vertex.Backend.Testing do
  @behaviour Vertex.Backend

  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def record(metrics) when is_list(metrics) do
    Agent.update(@name, fn state -> state ++ metrics end)
  end

  def record(metric) do
    record([metric])
  end

  def metrics do
    Agent.get(@name, & &1)
  end

  def reset! do
    Agent.update(@name, fn _state -> [] end)
  end
end
