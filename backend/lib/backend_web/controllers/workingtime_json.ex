import Ecto.Query, only: [from: 2]

defmodule BackendWeb.WorkingtimeJSON do
  alias Backend.WorkingTime.Workingtime

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(workingtime <- workingtime, do: data(workingtime))}
  end

  @doc """
  Renders a single workingtime.
  """
  def show(%{workingtime: workingtime}) do
    %{data: data(workingtime)}
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

  defp data(%Workingtime{} = workingtime) do
    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end
    }
  end
end
