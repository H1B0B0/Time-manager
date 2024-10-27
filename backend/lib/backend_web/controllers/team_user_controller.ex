defmodule BackendWeb.TeamUserController do
  use BackendWeb, :controller

  alias Backend.Teams
  alias Backend.Teams.Team
  alias Backend.TeamsUsers
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Repo

  action_fallback BackendWeb.FallbackController

  def show(conn, %{"team_id" => id}) do
    case Teams.get_team(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found"]})
        |> halt()

      team ->
        users = TeamsUsers.get_users_for_team(team)

        conn
        |> put_status(:ok)
        |> render(:index_users, users: users)
    end
  end

  def show(conn, %{"user_id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found"]})
        |> halt()

      user ->
        teams = TeamsUsers.get_teams_for_user(user)

        conn
        |> put_status(:ok)
        |> render(:index_teams, teams: teams)
    end
  end

  def create(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    user = Accounts.get_user(user_id)
    team = Teams.get_team(team_id)

    cond do
      user === nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found, no create made"]})
        |> halt()

      team === nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found, no create made"]})
        |> halt()

      true ->
        case TeamsUsers.add_user_to_team(user, team) do
          {:ok, _team_user} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "User added to team successfully."})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: changeset})
            |> halt()
        end
    end
  end

  def delete(conn, %{"user_id" => id, "team_id" => team_id}) do
    user = Accounts.get_user(id)
    team = Teams.get_team(team_id)

    cond do
      user === nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found, no delete made"]})
        |> halt()

      team === nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found, no delete made"]})
        |> halt()

      true ->
        case TeamsUsers.remove_user_from_team(user, team) do
          {:ok, _team_user} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "User removed from team successfully."})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: changeset})
            |> halt()
        end
    end
  end
end
