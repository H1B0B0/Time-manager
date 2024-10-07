defmodule Backend.TimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Times` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2024-10-06 09:50:00Z]
      })
      |> Backend.Times.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 09:50:00Z],
        start: ~U[2024-10-06 09:50:00Z]
      })
      |> Backend.Times.create_working_time()

    working_time
  end
end
