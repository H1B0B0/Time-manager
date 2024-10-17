defmodule BackendWeb.UserTeamController do
  use BackendWeb, :controller

  alias Backend.Teams
  alias Backend.Teams.Team
  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  def update(conn, %{"id" => id, "team_id" => team_id}) do
    team = Teams.get_team(team_id)
    user = Accounts.get_user(id)

    if user === nil do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["User not found, no update made"]})
      |> halt()
    end

    if team === nil do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["Team not found, no update made"]})
      |> halt()
    end

    user_params = %{}
    user_params = Map.put(user_params, "team_id", team_id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    if user === nil do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["User not found, no delete made"]})
      |> halt()
    end

    user_params = %{}
    user_params = Map.put(user_params, "team_id", nil)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end
end
