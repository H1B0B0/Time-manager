defmodule Backend.WorkingTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.WorkingTime` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-06 12:13:00],
        start: ~N[2024-10-06 12:13:00]
      })
      |> Backend.WorkingTime.create_workingtime()

    workingtime
  end
end
