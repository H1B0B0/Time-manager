defmodule BackendWeb.RoleController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.Role

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    roles = Accounts.list_roles()
    render(conn, :index, roles: roles)
  end

  def show(conn, %{"role_id" => id}) do
    role = Accounts.get_role(id)
    case role do
      nil -> conn
      |> put_status(:not_found)
      |> json(%{errors: ["Role not found"]})
      _ -> render(conn, :show, role: role)
    end
  end
end
