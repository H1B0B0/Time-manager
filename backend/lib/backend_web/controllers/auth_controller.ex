defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Hex.API.User
  alias Backend.Accounts
  alias Backend.Accounts.User
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

  def user(conn, %{"token" => token}) do
    case Auth.get_user_from_token(token) do
      {:ok, %User{id: user_id}} when is_integer(user_id) ->
        user = Accounts.get_user(user_id)
        case user do
          nil ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "User not found"})

          user ->
            conn
            |> put_status(:ok)
            |> render(:show, user: user)
        end

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end
end
