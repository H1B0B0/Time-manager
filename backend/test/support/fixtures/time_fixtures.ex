defmodule Backend.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Time` context.
  """

  alias Backend.Time
  alias Backend.Accounts

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    unique_id = System.unique_integer([:positive])
    email = "test#{unique_id}@example.com"

    role = Backend.AccountsFixtures.role_fixture()
    {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password", role_id: role.id})

    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-06 12:11:00],
        user_id: user.id
      })
      |> Time.create_clock()

    clock
  end
end
