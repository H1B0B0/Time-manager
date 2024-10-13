defmodule Backend.WorkingTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.WorkingTime` context.
  """
  alias Backend.Accounts

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    unique_id = System.unique_integer([:positive])
    email = "test#{unique_id}@example.com"
    role = Backend.AccountsFixtures.role_fixture()
    {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password", role_id: role.id})

    attrs = Enum.into(attrs, %{
      start: ~N[2024-10-06 12:13:00],
      end: ~N[2024-10-06 12:13:00],
      user_id: user.id
    })

    case Backend.WorkingTime.create_workingtime(attrs) do
      {:ok, workingtime} -> workingtime
      {:error, changeset} -> raise "Failed to create workingtime: #{inspect(changeset)}"
    end
  end
end
