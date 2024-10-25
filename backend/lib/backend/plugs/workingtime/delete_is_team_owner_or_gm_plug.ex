defmodule Backend.Plugs.Workingtime.DeleteIsTeamOwnerOrGMPlug do
  import Plug.Conn
  import Phoenix.Controller
  require Logger
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Enums.RolesEnum
  alias Backend.TeamsUsers
  alias Backend.WorkingTime

  def init(default), do: default

  def call(conn, _opts) do
    auth_user = conn.assigns[:auth_user]
    Logger.info("Authenticated user: #{inspect(auth_user)}")

    if auth_user.role_id >= RolesEnum.role_general_manager do
      Logger.info("User is a General Manager, access granted.")
      conn
    else
      working_time_id = conn.params["working_time_id"]
      Logger.info("Working time ID from params: #{inspect(working_time_id)}")

      working_time = WorkingTime.get_workingtime(working_time_id)
      Logger.info("Fetched working time: #{inspect(working_time)}")

      if working_time == nil do
        Logger.error("Working time not found for ID: #{inspect(working_time_id)}")
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})
        |> halt()
      end

      user_id = working_time.user_id
      Logger.info("User ID from working time: #{inspect(user_id)}")

      if user_id == auth_user.id do
        Logger.info("User is deleting their own working time, access granted.")
        conn
      else
        user = Accounts.get_user(user_id)
        Logger.info("Fetched user: #{inspect(user)}")

        if user == nil do
          Logger.error("User not found for ID: #{inspect(user_id)}")
          conn
          |> put_status(:not_found)
          |> json(%{error: "User not found"})
          |> halt()
        end

        user_teams = TeamsUsers.get_teams_by_user(user)
        Logger.info("Fetched user teams: #{inspect(user_teams)}")

        if user_teams == nil do
          Logger.error("Teams not found for user: #{inspect(user)}")
          conn
          |> put_status(:not_found)
          |> json(%{error: "Teams not found"})
          |> halt()
        end

        if Enum.any?(user_teams, fn user_team -> user_team.team.owner_id == auth_user.id end) do
          Logger.info("User is a team owner, access granted.")
          conn
        else
          Logger.error("Permission denied for user: #{inspect(auth_user)}")
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Permission denied"})
          |> halt()
        end
      end
    end
  end
end
