defmodule Backend.Plugs.Workingtime.DeleteIsTeamOwnerOrGMPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Enums.RolesEnum
  alias Backend.TeamsUsers

  def init(default), do: default

  def call(conn, _opts) do
    auth_user = conn.assigns[:auth_user]

    if auth_user.role_id in [RolesEnum.role_general_manager] do
      conn
    else
      working_time_id = conn.params["working_time_id"]
      working_time = Time.get_working_time(working_time_id)

      if working_time == nil do
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})
        |> halt
      end

      user_id = working_time.user_id
      user = Accounts.get_user(user_id)

      if user == nil do
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
        |> halt
      end

      user_teams = TeamsUsers.get_teams_by_user(user)

      if user_teams == nil do
        conn
        |> put_status(:not_found)
        |> json(%{error: "Teams not found"})
        |> halt
      end

      for user_team <- user_teams do
        if user_team.team.owner_id == auth_user.id do
          conn
        end
      end

      conn
      |> put_status(:forbidden)
      |> json(%{error: "Permission denied"})
      |> halt
    end
  end
end
