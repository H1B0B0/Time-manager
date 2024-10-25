defmodule Backend.WorkingTime do
  @moduledoc """
  The WorkingTime context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.WorkingTime.Workingtime

  @doc """
  Returns the list of workingtime.

  ## Examples

      iex> list_workingtime()
      [%Workingtime{}, ...]

  """
  def list_workingtime do
    Repo.all(Workingtime)
  end

  @doc """
  Gets a single workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(123)
      %Workingtime{}

      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  def get_workingtime(id), do: Repo.get(Workingtime, id)

  @doc """
  Gets a single workingtime by user ID and workingtime ID.

  Returns `nil` if no matching record is found.

  ## Examples

      iex> get_workingtime_by_user_and_id(1, 123)
      %Workingtime{}

      iex> get_workingtime_by_user_and_id(1, 456)
      nil

  """
  def get_workingtime_by_user_and_id(user_id, id) do
    Repo.get_by(Workingtime, user_id: user_id, id: id)
  end

  @doc """
  Creates a workingtime.

  ## Examples

      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}

      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.

  ## Examples

      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}

      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtime.

  ## Examples

      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}

      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}

  """
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  @doc """
  Returns a list of workingtimes for a user within a date range.

  ## Examples

      iex> get_workingtime_user_and_date(1, ~N[2023-01-01 00:00:00], ~N[2023-01-31 23:59:59])
      [%Workingtime{}, ...]

  """
  def get_workingtime_user_and_date(user_id, start_time, end_time) do
    query = from w in Workingtime,
      where: w.user_id == ^user_id and w.start >= ^start_time and w.end <= ^end_time,
      select: w

    Repo.all(query)
  end
end
