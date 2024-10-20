defmodule BackendWeb.AuthJSON do
  alias Backend.Accounts.User

  @doc """
  Renders a single user with token.
  """
  def show(%{user: user, token: token}) do
    %{data: data(user), token: token}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role_id: user.role_id,
      role: user.role.category,
      team_id: user.team_id
    }
  end
end
