defmodule BackendWeb.ClockControllerTest do
  use BackendWeb.ConnCase

  import Backend.TimeFixtures
  alias Backend.Accounts
  alias Backend.Time.Clock

  @create_attrs %{
    status: true,
    time: ~N[2024-10-06 12:11:00]
  }
  @invalid_attrs %{status: nil, time: nil, user_id: nil}

  setup %{conn: conn} do
    unique_id = System.unique_integer([:positive])
    email = "test#{unique_id}@example.com"
    {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password"})
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn, user: user} do
      create_attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{user.id}")

      assert [
               %{
                 "id" => ^id,
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
end
