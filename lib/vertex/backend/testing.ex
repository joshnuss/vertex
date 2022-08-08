defmodule Vertex.Backend.Testing do
  @behaviour Vertex.Backend

  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def record(metric) do
    Agent.update(@name, fn state -> state ++ [metric] end)
  end

  def metrics do
    Agent.get(@name, & &1)
  end

  def reset! do
    Agent.update(@name, fn _state -> [] end)
  end
end
