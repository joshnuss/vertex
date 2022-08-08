defmodule Vertex.Backend.Clickhouse do
  @behaviour Vertex.Backend

  @config Application.get_env(:vertex, :clickhouse)
  @database Keyword.fetch!(@config, :database)
  @url Keyword.fetch!(@config, :url)
  @user Keyword.fetch!(@config, :user)
  @password Keyword.fetch!(@config, :password)
  @req Req.new(base_url: @url)

  def record(metrics) when is_list(metrics) do
    query = build_query(metrics)

    %{status: 200} =
      Req.post!(@req,
        url: "/",
        params: %{database: @database, query: ""},
        body: query,
        auth: {@user, @password}
      )

    :ok
  end

  def record(metric), do: record([metric])

  defp build_query(metrics) do
    values = Enum.map_join(metrics, ",\n", &build_values/1)

    """
    INSERT INTO metrics (project, account_id, event, tags)
    FORMAT Values #{values}
    """
  end

  defp build_values(metric) do
    tags = Enum.map_join(metric.tags, ",", &"'#{&1}'")

    ~s|('#{metric.project}', '#{metric.account_id}', '#{metric.event}', [#{tags}])|
  end
end
