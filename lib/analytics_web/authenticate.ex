defmodule AnalyticsWeb.Authenticate do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  @access_token Application.get_env(:analytics, :access_token)

  def init(options), do: options

  def call(conn, _opts) do
    authorization = get_req_header(conn, "authorization")

    if authorization == ["Bearer " <> @access_token] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "invalid access token"})
      |> halt()
    end
  end
end
