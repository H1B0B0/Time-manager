defmodule Backend.Plugs.IsTeamOwnerOrGMPlug do
  import Plug.Conn
  import Phoenix.Controller
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

    cond do
      auth_user.role_id in [RolesEnum.role_general_manager] ->
        conn

      conn.params["team_id"] ->
        team_id = conn.params["team_id"]
        team = Teams.get_team(team_id)

        if team == nil do
          conn
          |> put_status(:not_found)
          |> json(%{error: "Team not found"})
          |> halt()
        else
          if auth_user.id == team.owner_id do
            conn
          else
            conn
            |> put_status(:forbidden)
            |> json(%{error: "Permission denied"})
            |> halt()
          end
        end

      conn.params["user_id"] ->
        user = Accounts.get_user(user_id)

        if user == nil do
          conn
          |> put_status(:not_found)
          |> json(%{error: "User not found"})
          |> halt()
        else
          teams_user = TeamsUsers.get_teams_for_user(user)

          if teams_user == nil do
            conn
            |> put_status(:not_found)
            |> json(%{error: "Teams not found"})
            |> halt()
          else
            if Enum.any?(teams_user, fn team -> team.owner_id == auth_user.id end) do
              conn
            else
              conn
              |> put_status(:forbidden)
              |> json(%{error: "Permission denied"})
              |> halt()
            end
          end
        end

      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Permission denied"})
        |> halt()
    end
  end
end
