defmodule BackendWeb.WorkingtimeControllerTest do
  use BackendWeb.ConnCase

  alias Backend.WorkingTime
  alias Backend.WorkingTime.Workingtime
  alias BackendWeb.Router.Helpers, as: Routes

  import Backend.WorkingTimeFixtures

  @create_attrs %{start: ~N[2024-10-06 12:13:00], end: ~N[2024-10-06 12:13:00]}
  @update_attrs %{start: ~N[2024-10-07 12:13:00], end: ~N[2024-10-07 12:13:00]}
  @invalid_attrs %{start: nil, end: nil}

  setup do
    {:ok, user} = Backend.Accounts.create_user(%{username: "testuser", name: "Test User", email: "test@example.com", password: "password"})
    {:ok, user: user}
  end

  test "creates workingtime and returns 201 when data is valid", %{conn: conn, user: user} do
    conn = post(conn, Routes.workingtime_path(conn, :create, user.id), workingtime: Map.put(@create_attrs, :user_id, user.id))
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, Routes.workingtime_path(conn, :show, user.id, id))
    assert json_response(conn, 200)["data"]["id"] == id
  end

  test "does not create workingtime and returns 422 when data is invalid", %{conn: conn, user: user} do
    conn = post(conn, Routes.workingtime_path(conn, :create, user.id), workingtime: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates workingtime and returns 200 when data is valid", %{conn: conn, user: user} do
    workingtime = workingtime_fixture(%{user_id: user.id})
    conn = put(conn, Routes.workingtime_path(conn, :update, user.id, workingtime.id), workingtime: @update_attrs)
    assert json_response(conn, 200)["data"]["id"] == workingtime.id

    conn = get(conn, Routes.workingtime_path(conn, :show, user.id, workingtime.id))
    assert json_response(conn, 200)["data"]["start"] == "2024-10-07T12:13:00"
  end

  test "does not update workingtime and returns 422 when data is invalid", %{conn: conn, user: user} do
    workingtime = workingtime_fixture(%{user_id: user.id})
    conn = put(conn, Routes.workingtime_path(conn, :update, user.id, workingtime.id), workingtime: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes workingtime and returns 204", %{conn: conn, user: user} do
    workingtime = workingtime_fixture(%{user_id: user.id})
    conn = delete(conn, Routes.workingtime_path(conn, :delete, user.id, workingtime.id))
    assert response(conn, 204)

    assert_error_sent 404, fn ->
      get(conn, Routes.workingtime_path(conn, :show, user.id, workingtime.id))
    end
  end

  test "lists all workingtime for a user", %{conn: conn, user: user} do
    conn = get(conn, Routes.workingtime_path(conn, :index, user.id))
    assert json_response(conn, 200)["data"] == []
  end
end
