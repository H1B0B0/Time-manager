defmodule BackendWeb.TeamUserJSON do
  alias Backend.Accounts.User
  alias Backend.Teams.Team

  @doc """
  Renders a single user.
  """
  def show_user(%{user: user}) do
    %{data: render_user(user)}
  end

  @doc """
  Renders a list of users.
  """
  def index_users(%{users: users}) do
    for(user <- users, do: render_user(user))
  end

  @doc """
  Renders a single team.
  """
  def show_team(%{team: team}) do
    %{data: render_team(team)}
  end

  @doc """
  Renders a list of teams.
  """
  def index_teams(%{teams: teams}) do
    for(team <- teams, do: render_team(team))
  end

  defp render_team(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      owner_id: team.owner_id
    }
  end

  defp render_user(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role_id: user.role_id,
      role: user.role.category
    }
  end
end
