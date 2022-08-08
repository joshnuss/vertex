defmodule VertexWeb.PingController do
  use VertexWeb, :controller

  def index(conn, _params) do
    text(conn, "pong")
  end
end
