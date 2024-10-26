defmodule Backend.Plugs.IsTeamOwnerOrGMPlug do
  import Plug.Conn
  import Phoenix.Controller
  require Logger
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Enums.RolesEnum
  alias Backend.TeamsUsers
  alias Backend.Teams

  def init(default), do: default

  def call(conn, _opts) do
    auth_user = conn.assigns[:auth_user]
    user_id = conn.params["user_id"]
    Logger.info("Authenticated user: #{inspect(auth_user)}")
    Logger.info("User ID from params: #{inspect(user_id)}")

    cond do
      auth_user.role_id >= RolesEnum.role_general_manager ->
        Logger.info("User is a General Manager or higher, access granted.")
        conn

      conn.params["team_id"] ->
        team_id = conn.params["team_id"]
        Logger.info("Team ID from params: #{inspect(team_id)}")
        team = Teams.get_team(team_id)
        Logger.info("Fetched team: #{inspect(team)}")

        if team == nil do
          Logger.error("Team not found for ID: #{inspect(team_id)}")
          conn
          |> put_status(:not_found)
          |> json(%{error: "Team not found"})
          |> halt()
        else
          if auth_user.id == team.owner_id do
            Logger.info("User is the owner of the team, access granted.")
            conn
          else
            Logger.error("Permission denied: User is not the owner of the team.")
            conn
            |> put_status(:forbidden)
            |> json(%{error: "Permission denied"})
            |> halt()
          end
        end

      conn.params["user_id"] ->
        user = Accounts.get_user(user_id)
        Logger.info("Fetched user: #{inspect(user)}")

        if user == nil do
          Logger.error("User not found for ID: #{inspect(user_id)}")
          conn
          |> put_status(:not_found)
          |> json(%{error: "User not found"})
          |> halt()
        else
          if auth_user.id == user.id do
            Logger.info("User is modifying their own working time, access granted.")
            conn
          else
            teams_user = TeamsUsers.get_teams_for_user(user)
            Logger.info("Fetched teams for user: #{inspect(teams_user)}")

            if teams_user == nil do
              Logger.error("Teams not found for user: #{inspect(user)}")
              conn
              |> put_status(:not_found)
              |> json(%{error: "Teams not found"})
              |> halt()
            else
              if Enum.any?(teams_user, fn team -> team.owner_id == auth_user.id end) do
                Logger.info("User is a team owner, access granted.")
                conn
              else
                Logger.error("Permission denied: User is not a team owner.")
                conn
                |> put_status(:forbidden)
                |> json(%{error: "Permission denied"})
                |> halt()
              end
            end
          end
        end

      true ->
        Logger.error("Permission denied: No valid conditions met.")
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Permission denied"})
        |> halt()
    end
  end
end
