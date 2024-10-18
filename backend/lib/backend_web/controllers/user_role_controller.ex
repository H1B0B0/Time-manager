defmodule BackendWeb.UserRoleController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  def update(conn, %{"user_id" => id, "role_id" => role_id}) do
    user = Accounts.get_user(id)
    role_id = String.to_integer(role_id)

    if !user do
      conn
      |> put_status(:not_found)
      |> json(%{errors: ["User not found, no update made"]})
    else
      if role_id > 3 or role_id < 1 do
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["Invalid role_id"]})
      else
        user_params = %{}
        user_params = Map.put(user_params, "role_id", role_id)

        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          conn
          |> put_status(:ok)
          |> render(:show, user: user)
        end
      end
    end
  end
end
