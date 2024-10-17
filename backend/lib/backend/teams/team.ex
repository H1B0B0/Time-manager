defmodule Backend.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :owner, Backend.User, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
