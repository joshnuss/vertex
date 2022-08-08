defmodule VertexWeb.Authenticate do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias Vertex.Project

  def init(options), do: options

  def call(conn, _opts) do
    authorization = get_req_header(conn, "authorization")
    access_token = get_access_token(authorization)
    project = Project.get(access_token)

    if project do
      assign(conn, :project, project)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "invalid access token"})
      |> halt()
    end
  end

  defp get_access_token(["Bearer " <> access_token]), do: access_token
  defp get_access_token(_), do: nil
end
