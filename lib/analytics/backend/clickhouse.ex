defmodule Analytics.Backend.Clickhouse do
  @behaviour Analytics.Backend

  @config Application.get_env(:analytics, :clickhouse)
  @database Keyword.fetch!(@config, :database)
  @url Keyword.fetch!(@config, :url)
  @user Keyword.fetch!(@config, :user)
  @password Keyword.fetch!(@config, :password)
  @req Req.new(base_url: @url)

  def record(metric) do
    query = build_query(metric)

    %{status: 200} = Req.post!(@req,
      url: "/",
      params: %{ database: @database, query: "" },
      body: query,
      auth: { @user, @password }
    )

    :ok
  end

  defp build_query(metric) do
    tags = Enum.map_join(metric.tags, ",", &"'#{&1}'")

    """
    INSERT INTO metrics (project, account_id, event, tags)
    VALUES (
      '#{metric.project}',
      '#{metric.account_id}',
      '#{metric.event}',
      [#{tags}]
    )
    """
  end
end
