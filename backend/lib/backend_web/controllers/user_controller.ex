defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Hex.API.User
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Auth

  action_fallback BackendWeb.FallbackController

  def getAllUsers(conn, _params) do
    users = Accounts.get_all_users()
    case users do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found"]})
      _ ->
        render(conn, :index, users: users)
    end
  end

  def getUserByTeam(conn, %{"team_id" => team_id}) do
    users = Accounts.get_users_by_team(team_id)
    case users do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found"]})
      _ ->
        render(conn, :index, users: users)
    end
  end

  def index(conn, %{"email" => email, "username" => username}) do
    user = Accounts.get_user_by_username_and_email(username, email)
    case user do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found"]})

      _ ->
        render(conn, :show, user: user)
    end
  end

  def show(conn, %{"user_id" => id}) do
    user = Accounts.get_user(id)
    case user do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["User not found"]})

      _ ->
        render(conn, :show, user: user)
    end
  end

  def create(conn, %{"user" => user_params}) do
    user_params = Map.put(user_params, "role_id", 1) # Employee (default role)

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def update(conn, %{"user_id" => id, "user" => user_params}) do
    user = Accounts.get_user(id)

    # The user can't update his own role
    user_params = Map.delete(user_params, "role_id")
    # The user can't update his own team
    user_params = Map.delete(user_params, "team_id")

    if !user do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["User not found, no update made"]})
    else
      case user_params do
        %{"old_password" => old_password} ->
          if Pbkdf2.verify_pass(old_password, user.password) do
            with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
              render(conn, :show, user: user)
            end
          else
            conn
            |> put_status(:unauthorized)
            |> json(%{errors: ["Old password is incorrect"]})
          end

        %{"password" => _new_password} ->
          conn
          |> put_status(:bad_request)
          |> json(%{errors: ["Old password is required"]})

        _ ->
          with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
            render(conn, :show, user: user)
          end
      end
    end
  end

  def delete(conn, %{"user_id" => id}) do
    user = Accounts.get_user(id)

    if !user do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["User not found, no delete made"]})
    else
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
