defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Auth

  action_fallback BackendWeb.FallbackController

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user =
      cond do
        email != "" -> Accounts.get_user_by_email(email)
        true -> nil
      end

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User not found"})

      user ->
        case Auth.sign_in(user.id, password) do
          {:ok, %{token: token}} ->
            conn
            |> put_status(:ok)
            |> render(:show, user: user, token: token)

          {:error, reason} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: reason})
        end
    end
  end

  def user(conn, _params) do
    user = conn.assigns[:current_user]

    conn
    |> put_status(:ok)
    |> render(:show, user: user)
  end
end
