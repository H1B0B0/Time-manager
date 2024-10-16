defmodule Backend.Plugs.AuthenticationPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User

  def init(default), do: default

  def call(conn, _opts) do
    authorization_header = get_req_header(conn, "authorization") |> List.first()

    if authorization_header do
      IO.puts("Authorization Header: #{authorization_header}")

      token = String.replace_prefix(authorization_header, "Bearer ", "")

      case Auth.get_user_from_token(token) do
        {:ok, %User{id: user_id}} when is_integer(user_id) ->
          user = Accounts.get_user(user_id)

          if user == nil do
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "User not found"})
            |> halt()
          else
            conn  # Return the connection if user is found
          end

        {:error, reason} ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: reason})
          |> halt()
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Authorization header is missing"})
      |> halt()
    end
  end
end
