defmodule AnalyticsWeb.PingController do
  use AnalyticsWeb, :controller

  def index(conn, _params) do
    text(conn, "pong")
  end
end
