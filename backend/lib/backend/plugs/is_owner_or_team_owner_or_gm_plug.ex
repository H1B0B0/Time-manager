defmodule Backend.Plugs.IsOwnerOrTeamOwnerOrGMPlug do
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
    user_id = conn.params["user_id"]

    cond do
      auth_user.id == String.to_integer(user_id) ->
        conn

      auth_user.role_id >= RolesEnum.role_general_manager ->
        conn

      conn.params["team_id"] ->
        team_id = conn.params["team_id"]
        team = Accounts.get_team(team_id)

        if team == nil do
          conn
          |> put_status(:not_found)
          |> json(%{error: "Team not found"})
          |> halt()
        end

        if auth_user.id == team.owner_id do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Permission denied"})
          |> halt()
        end

      conn.params["user_id"] ->
        user = Accounts.get_user(user_id)

        if user == nil do
          conn
          |> put_status(:not_found)
          |> json(%{error: "User not found"})
          |> halt()
        end

        teams_user = TeamsUsers.get_teams_for_user(user)
        if Enum.any?(teams_user, fn team -> team.owner_id == auth_user.id end) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Permission denied"})
          |> halt()
        end

      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Permission denied"})
        |> halt()
    end
  end
end
