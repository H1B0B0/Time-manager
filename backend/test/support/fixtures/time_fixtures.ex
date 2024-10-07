defmodule Backend.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Time` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-06 12:11:00]
      })
      |> Backend.Time.create_clock()

    clock
  end
end
