defmodule BackendWeb.RoleControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures

  alias Backend.Accounts.Role
  alias Backend.Auth

  @create_attrs %{
    category: "some category"
  }
  @update_attrs %{
    category: "some updated category"
  }
  @invalid_attrs %{category: nil}

  setup %{conn: conn} do
    unique_id = System.unique_integer([:positive])
    email = "test#{unique_id}@example.com"
    role = role_fixture()
    {:ok, user} = Backend.Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password", role_id: role.id})

    # Generate a token for the user using Joken
    {:ok, token, _claims} = Auth.generate_and_sign(%{"user_id" => user.id})

    # Add the token to the request headers
    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      %{role: role} = create_role()
      conn = get(conn, ~p"/api/roles")
      response_data = json_response(conn, 200)["data"]
      assert Enum.any?(response_data, fn r -> r["id"] == role.id and r["category"] == role.category end)
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
