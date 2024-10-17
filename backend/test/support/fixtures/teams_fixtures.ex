defmodule Backend.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Teams` context.
  """

  alias Backend.AccountsFixtures

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name",
        owner_id: user.id  # Utilisez l'ID de l'utilisateur créé
      })
      |> Backend.Teams.create_team()

    team
  end
end
