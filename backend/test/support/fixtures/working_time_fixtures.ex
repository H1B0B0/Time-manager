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
    {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password"})

    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        start: "2024-10-06 12:13:00",
        end: "2024-10-06 12:13:00",
        user_id: user.id
      })
      |> Backend.WorkingTime.create_workingtime()

    workingtime
  end
end
