defmodule BackendWeb.WorkingtimeController do
  use BackendWeb, :controller

  alias Backend.WorkingTime
  alias Backend.WorkingTime.Workingtime

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    workingtime = WorkingTime.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"userID" => userID, "id" => id}) do
    case WorkingTime.get_workingtime_by_user_and_id(userID, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        render(conn, :show, workingtime: workingtime)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- WorkingTime.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  def getAll(conn, %{"userID" => userID, "start" => startTime, "end" => endTime}) do
    startTime = DateTime.from_iso8601!(startTime)
    endTime = DateTime.from_iso8601!(endTime)
    case Workingtime.get_workingtime_user_and_date(userID,startTime,endTime) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        render(conn, :getAll, workingtime: workingtime)
    end
  end
end
