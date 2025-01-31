defmodule Backend.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :owner, Backend.Accounts.User, foreign_key: :owner_id

    many_to_many :users, Backend.Accounts.User, join_through: "teams_users", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
    |> foreign_key_constraint(:owner_id)
  end
end
