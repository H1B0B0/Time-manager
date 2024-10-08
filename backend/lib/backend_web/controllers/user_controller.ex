defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Hex.API.User
  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  # - a GET method : http://localhost:4000/api/users?email=XXX&username=YYY
  # – a GET method : http://localhost:4000/api/users/:userID
  # – a POST method : http://localhost:4000/api/users
  # – a PUT method : http://localhost:4000/api/users/:userID
  # – a DELETE method : http://localhost:4000/api/users/:userID

  def index(conn, %{"email" => email, "username" => username}) do
    user = Accounts.get_user_by_username_and_email(username, email)
    render(conn, :show, user: user)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
