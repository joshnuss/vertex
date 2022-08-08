defmodule VertexWeb.Controllers.PingControllerTest do
  use VertexWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/ping")

    assert text_response(conn, 200) == "pong"
  end
end
