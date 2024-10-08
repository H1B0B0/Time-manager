defmodule BackendWeb.WorkingtimeControllerTest do
  use BackendWeb.ConnCase

  import Backend.WorkingTimeFixtures

  alias Backend.WorkingTime.Workingtime

  @create_attrs %{
    start: "2024-10-06 12:13:00",
    end: "2024-10-06 12:13:00"
  }
  @update_attrs %{
    start: "2024-10-07 12:13:00",
    end: "2024-10-07 12:13:00"
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtime", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtime")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", workingtime: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-06T12:13:00",
               "start" => "2024-10-06T12:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show workingtime" do
    setup [:create_workingtime]

    test "renders workingtime when data is valid", %{
      conn: conn,
      workingtime: %Workingtime{id: id, user_id: user_id}
    } do
      conn = get(conn, ~p"/api/workingtime/#{user_id}/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-06T12:13:00",
               "start" => "2024-10-06T12:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when workingtime not found", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtime/999/999")
      assert json_response(conn, 404)["error"] == "Workingtime not found"
    end
  end

  describe "update workingtime" do
    setup [:create_workingtime]

    test "renders workingtime when data is valid", %{
      conn: conn,
      workingtime: %Workingtime{id: id}
    } do
      conn = put(conn, ~p"/api/workingtime/#{id}", workingtime: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T12:13:00",
               "start" => "2024-10-07T12:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
      conn = put(conn, ~p"/api/workingtime/#{workingtime.id}", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    setup [:create_workingtime]

    test "deletes chosen workingtime", %{conn: conn, workingtime: workingtime} do
      conn = delete(conn, ~p"/api/workingtime/#{workingtime.id}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/workingtime/#{workingtime.id}")
      end)
    end
  end

  describe "getAll workingtime" do
    setup [:create_workingtime]

    test "lists workingtime for a user within a date range", %{
      conn: conn,
      workingtime: %Workingtime{user_id: user_id}
    } do
      start_time = "2024-10-01T00:00:00Z"
      end_time = "2024-10-31T23:59:59Z"
      conn = get(conn, ~p"/api/workingtime/#{user_id}?start=#{start_time}&end=#{end_time}")
      assert json_response(conn, 200)["data"] != []
    end

    test "renders errors when no workingtime found", %{conn: conn} do
      start_time = "2024-10-01T00:00:00Z"
      end_time = "2024-10-31T23:59:59Z"
      conn = get(conn, ~p"/api/workingtime/999?start=#{start_time}&end=#{end_time}")
      assert json_response(conn, 404)["error"] == "Workingtime not found"
    end
  end

  defp create_workingtime(_) do
    workingtime = workingtime_fixture()
    %{workingtime: workingtime}
  end
end
