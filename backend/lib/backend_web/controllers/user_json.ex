defmodule BackendWeb.UserJSON do
  alias Backend.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    users = users || []
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    if user do
      %{data: data(user)}
    else
      %{errors: ["User not found"]}
    end
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
