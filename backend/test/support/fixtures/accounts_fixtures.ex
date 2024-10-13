defmodule Backend.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "john.doe@mail.com",
        username: "John Doe"
      })
      |> Backend.Accounts.create_user()

    user
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        category: "some category"
      })

    {:ok, role} = Backend.Accounts.create_role(attrs)
    role
  end
end
