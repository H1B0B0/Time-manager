defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts
  alias Backend.Auth
  alias Backend.Accounts.User
  import Backend.AccountsFixtures

  @create_attrs %{
    username: "John Doe",
    email: "john.doe@mail.com"
  }
  @update_attrs %{
    username: "Jane Doe",
    email: "jane.doe@mail.zz"
  }
  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    unique_id = System.unique_integer([:positive])
    email = "test#{unique_id}@example.com"
    role = Backend.AccountsFixtures.role_fixture()
    {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password", role_id: role.id})

    # Generate a token for the user using Joken
    {:ok, token, _claims} = Auth.generate_and_sign(%{"user_id" => user.id})

    # Add the token to the request headers
    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user}
  end

  test "renders errors when user is not found", %{conn: conn} do
    conn = get(conn, "/api/users", email: "", username: "")
    assert json_response(conn, 404)["errors"] != %{}
  end

  describe "show user based on id" do
    setup [:create_user]

    test "shows user based on id", %{conn: conn, user: %User{id: id}} do
      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
        "email" => "john.doe@mail.com",
        "username" => "John Doe"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when user is not found", %{conn: conn} do
      conn = get(conn, ~p"/api/users/-1")
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{id}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "email" => "jane.doe@mail.zz",
               "username" => "Jane Doe"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)
    end

    test "renders errors when user is not found", %{conn: conn} do
      conn = delete(conn, ~p"/api/users/-1")
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
