defmodule Backend.Plugs.IsOwnerPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Enums.RolesEnum

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:auth_user]
    user_id = conn.params["user_id"]

    if user.id == String.to_integer(user_id) do
      conn
    else
      conn
        |> put_status(:forbidden)
        |> json(%{error: "Permission denied"})
        |> halt()
    end
  end
end
