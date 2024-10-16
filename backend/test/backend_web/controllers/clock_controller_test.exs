defmodule BackendWeb.ClockControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts
  alias Backend.Auth

  @create_attrs %{
    status: true,
    time: ~N[2024-10-06 12:11:00]
  }
  @invalid_attrs %{status: nil, time: nil, user_id: nil}

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
    defmodule BackendWeb.ClockControllerTest do
      use BackendWeb.ConnCase

      alias Backend.Accounts
      alias Backend.Auth

      @create_attrs %{
        status: true,
        time: ~N[2024-10-06 12:11:00]
      }
      @invalid_attrs %{status: nil, time: nil, user_id: nil}

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

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn, user: user} do
      create_attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{user.id}")

      assert [
               %{
                 "id" => id,
                 "status" => true,
                 "time" => "2024-10-06T12:11:00"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show clocks for user" do
    test "lists all clocks for a user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/clocks/#{user.id}")
      assert json_response(conn, 200)["data"] == []
        end
      end

      describe "update clock" do
        setup %{conn: conn, user: user} do
          create_attrs = Map.put(@create_attrs, :user_id, user.id)
          conn = post(conn, ~p"/api/clocks/#{user.id}", clock: create_attrs)
          %{"id" => clock_id} = json_response(conn, 201)["data"]
          {:ok, clock_id: clock_id}
        end

        test "updates clock when data is valid", %{conn: conn, user: user, clock_id: clock_id} do
          update_attrs = %{status: false, time: ~N[2024-11-06 12:11:00]}
          conn = put(conn, ~p"/api/clocks/#{user.id}/#{clock_id}", clock: update_attrs)
          assert %{"id" => ^clock_id, "status" => false, "time" => "2024-11-06T12:11:00"} = json_response(conn, 200)["data"]
        end

        test "renders errors when data is invalid", %{conn: conn, user: user, clock_id: clock_id} do
          conn = put(conn, ~p"/api/clocks/#{user.id}/#{clock_id}", clock: @invalid_attrs)
          assert json_response(conn, 422)["errors"] != %{}
        end
      end

      describe "delete clock" do
        setup %{conn: conn, user: user} do
          create_attrs = Map.put(@create_attrs, :user_id, user.id)
          conn = post(conn, ~p"/api/clocks/#{user.id}", clock: create_attrs)
          %{"id" => clock_id} = json_response(conn, 201)["data"]
          {:ok, clock_id: clock_id}
        end

        test "deletes clock", %{conn: conn, user: user, clock_id: clock_id} do
          conn = delete(conn, ~p"/api/clocks/#{user.id}/#{clock_id}")
          assert response(conn, 204)

          conn = get(conn, ~p"/api/clocks/#{user.id}")
          assert json_response(conn, 200)["data"] == []
        end
      end
    end
  end
end
