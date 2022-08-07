defmodule Analytics.Project do
  use Agent

  @name __MODULE__

  def start_link(_opts) do
    Agent.start_link(&load/0, name: @name)
  end

  defp load() do
    if File.exists?("projects.json") do
      File.read!("projects.json") |> Jason.decode!()
    else
      Application.get_env(:analytics, :projects)
    end
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end

  def get(nil), do: nil

  def get(access_token) do
    Agent.get(@name, fn state -> state[access_token] end)
  end
end
