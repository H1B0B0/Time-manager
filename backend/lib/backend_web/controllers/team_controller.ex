defmodule BackendWeb.TeamController do
  use BackendWeb, :controller
  alias Backend.Teams
  alias Backend.Teams.Team

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def show(conn, %{"id" => id}) do
    case Teams.get_team(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found"]})

      team ->
        render(conn, :show, team: team)
    end
  end

  def create(conn, %{"team" => team_params}) do
    case Teams.create_team(team_params) do
      {:ok, team} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/teams/#{team.id}")
        |> render(:show, team: team)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team(id)

    case team do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found, no update made"]})

      _ ->
        case Teams.update_team(team, team_params) do
          {:ok, team} ->
            render(conn, :show, team: team)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset.errors})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team(id)

    case team do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Team not found, no delete made"]})

      _ ->
        case Teams.delete_team(team) do
          {:ok, %Team{}} ->
            send_resp(conn, :no_content, "")

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{errors: ["Unable to delete team"]})
        end
    end
  end
end
