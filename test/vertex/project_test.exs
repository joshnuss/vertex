defmodule Vertex.ProjectTest do
  use ExUnit.Case

  alias Vertex.Project

  test "get/1" do
    assert Project.get("fake-access-token") == "site1"
    refute Project.get("invalie-access-token")
  end
end
