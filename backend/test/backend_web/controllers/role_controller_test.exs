defmodule BackendWeb.RoleControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures

  alias Backend.Accounts.Role

  @create_attrs %{
    category: "some category"
  }
  @update_attrs %{
    category: "some updated category"
  }
  @invalid_attrs %{category: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      %{role: role} = create_role()
      conn = get(conn, ~p"/api/roles")
      assert json_response(conn, 200)["data"] == [%{"id" => role.id, "category" => role.category}]
    end

    test "list a specific role", %{conn: conn} do
      %{role: role} = create_role()
      conn = get(conn, ~p"/api/roles/#{role.id}")
      assert json_response(conn, 200)["data"] == %{"id" => role.id, "category" => role.category}
    end
  end

  defp create_role() do
    role = role_fixture()
    %{role: role}
  end
end
