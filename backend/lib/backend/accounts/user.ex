defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string

    belongs_to :role, Backend.Accounts.Role
    many_to_many :teams, Backend.Teams.Team, join_through: "teams_users", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role_id, :password])
    |> validate_required([:username, :email, :role_id, :password])
    |> validate_format(:email, ~r/^[\w._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/i, message: "Is not a valid email", name: "invalid_email")
    |> unique_constraint(:email, message: "Has already been taken", name: "unique_email")
    |> foreign_key_constraint(:role_id)
  end
end
