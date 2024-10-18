import Ecto.Query, only: [from: 2]

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

  def show(conn, %{"user_id" => userID, "working_time_id" => id}) do
    case WorkingTime.get_workingtime_by_user_and_id(userID, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        render(conn, :show, workingtime: workingtime)
    end
  end

  def update(conn, %{"user_id" => userID, "workingtime" => workingtime_params}) do
    case WorkingTime.get_workingtime_by_user_and_id(userID, workingtime_params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        with {:ok, %Workingtime{} = updated_workingtime} <- WorkingTime.update_workingtime(workingtime, workingtime_params) do
          render(conn, :show, workingtime: updated_workingtime)
        else
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Workingtime not found"})
        end
    end
  end

  def delete(conn, %{"working_time_id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- WorkingTime.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BackendWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def getAll(conn, %{"user_id" => userID} = params) do
    startTime = Map.get(params, "start", DateTime.utc_now() |> DateTime.to_iso8601())
    endTime = Map.get(params, "end", DateTime.utc_now() |> DateTime.to_iso8601())

    case DateTime.from_iso8601(startTime) do
      {:ok, startTime, _} ->
        case DateTime.from_iso8601(endTime) do
          {:ok, endTime, _} ->
            case WorkingTime.get_workingtime_user_and_date(userID, startTime, endTime) do
              [] ->
                conn
                |> put_status(:ok)
                |> json(%{data: []})
              workingtimes ->
                render(conn, :index, workingtime: workingtimes)
            end
          _ ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid end time format"})
        end
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid start time format"})
    end
  end

  def get_workingtime_by_user_and_id(userID, id) do
    Repo.get_by(Workingtime, user_id: userID, id: id)
  end

  def get_workingtime_user_and_date(userID, startTime, endTime) do
    query = from w in Workingtime,
      where: w.user_id == ^userID and w.start >= ^startTime and w.end <= ^endTime,
      select: w

    Repo.all(query)
  end
end
