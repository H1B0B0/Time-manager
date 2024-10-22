defmodule Backend.Teams.TeamUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams_users" do
    belongs_to :team, Backend.Teams.Team
    belongs_to :user, Backend.Accounts.User
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:user_id)
  end
end
