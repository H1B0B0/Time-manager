defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures

  alias Backend.Accounts.User

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
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
        "id" => ^id,
        "email" => "john.doe@mail.com",
        "username" => "John Doe"
        } = json_response(conn, 200)["data"]
      end

      test "renders errors when data is invalid", %{conn: conn} do
        conn = post(conn, ~p"/api/users", user: @invalid_attrs)
        assert json_response(conn, 422)["errors"] != %{}
      end
    end

  describe "show user based on username and email" do
    setup [:create_user]

    test "shows user based on username and email", %{conn: conn, user: user} do
      conn = get(conn, "/api/users", email: @create_attrs.email, username: @create_attrs.username)

      assert %{
        "email" => "john.doe@mail.com",
        "username" => "John Doe"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when user is not found", %{conn: conn} do
      conn = get(conn, "/api/users", email: "", username: "")
      assert json_response(conn, 404)["errors"] != %{}
    end
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
               "id" => ^id,
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
