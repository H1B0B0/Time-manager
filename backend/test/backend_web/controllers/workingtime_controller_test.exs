defmodule BackendWeb.WorkingtimeControllerTest do
  use BackendWeb.ConnCase

  import Backend.WorkingTimeFixtures
  alias Backend.Accounts
  alias Backend.Auth

  @create_attrs %{
    start: ~N[2024-10-06 12:13:00],
    end: ~N[2024-10-06 12:13:00]
  }
  @update_attrs %{
    start: ~N[2024-10-07 12:13:00],
    end: ~N[2024-10-07 12:13:00]
  }
  @invalid_attrs %{start: nil, end: nil, user_id: -1}

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

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn, user: user} do
      create_attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, ~p"/api/workingtime/users", workingtime: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtime/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "start" => "2024-10-06T12:13:00",
               "end" => "2024-10-06T12:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      invalid_attrs = Map.put(@invalid_attrs, :user_id, user.id)
      conn = post(conn, ~p"/api/workingtime/users", workingtime: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workingtime" do
    test "renders workingtime when data is valid", %{conn: conn, user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      workingtime_id = workingtime.id
      update_attrs = Map.put(@update_attrs, :id, workingtime_id)
      conn = put(conn, ~p"/api/workingtime/#{user.id}", workingtime: update_attrs)
      assert %{"id" => ^workingtime_id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtime/#{user.id}/#{workingtime_id}")

      assert %{
               "id" => ^workingtime_id,
               "start" => "2024-10-07T12:13:00",
               "end" => "2024-10-07T12:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      workingtime_id = workingtime.id
      invalid_attrs = Map.put(@invalid_attrs, :id, workingtime_id)
      conn = put(conn, ~p"/api/workingtime/#{user.id}", workingtime: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    test "deletes workingtime and returns 204", %{conn: conn, user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      workingtime_id = workingtime.id
      conn = delete(conn, ~p"/api/workingtime/#{workingtime_id}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/workingtime/#{user.id}/#{workingtime_id}")
      assert response(conn, 404)
    end
  end

  describe "show workingtimes for user" do
    test "lists all workingtimes for a user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/workingtime/#{user.id}")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
