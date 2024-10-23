defmodule Backend.Plugs.IsManagerOrGMPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Backend.Auth
  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Enums.RolesEnum

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:auth_user]

    if user.role_id in [RolesEnum.role_manager, RolesEnum.role_general_manager] do
      conn
    else
      conn
        |> put_status(:forbidden)
        |> json(%{error: "Permission denied"})
        |> halt()
    end
  end
end
