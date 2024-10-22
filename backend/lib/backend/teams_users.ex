defmodule Backend.TeamsUsers do
  @moduledoc """
  The TeamsUsers context for managing user-team associations.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Teams.Team
  alias Backend.Accounts.User

  @doc """
  Adds a user to a team.

  ## Examples

      iex> add_user_to_team(team, user)
      {:ok, %Team{}}

      iex> add_user_to_team(team, bad_user)
      {:error, %Ecto.Changeset{}}

  """
  def add_user_to_team(%User{} = user, %Team{} = team) do
    team = Repo.preload(team, :users)

    team
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, [user | team.users])
    |> Repo.update()
  end

  @doc """
  Removes a user from a team.

  ## Examples

      iex> remove_user_from_team(team, user)
      {:ok, %Team{}}

      iex> remove_user_from_team(team, bad_user)
      {:error, %Ecto.Changeset{}}

  """
  def remove_user_from_team(%User{} = user, %Team{} = team) do
    team = Repo.preload(team, :users)
    users = Enum.reject(team.users, fn u -> u.id == user.id end)

    team
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, users)
    |> Repo.update()
  end

  @doc """
  Gets the users for a team.

  ## Examples

      iex> get_users_for_team(team)
      [%User{}, ...]

  """
  def get_users_for_team(%Team{} = team) do
    team
    |> Repo.preload(:users)
    |> Repo.preload(users: :role)
    |> Map.get(:users)
  end

  @doc """
  Gets the teams for a user.

  ## Examples

      iex> get_teams_for_user(user)
      [%Team{}, ...]

  """
  def get_teams_for_user(%User{} = user) do
    user
    |> Repo.preload(:teams)
    |> Map.get(:teams)
  end
end
