defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    belongs_to :role, Backend.Accounts.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role_id])
    |> validate_required([:username, :email, :role_id])
    |> validate_format(:email, ~r/^[\w._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/i, message: "is not a valid email")
    |> unique_constraint(:email, message: "has already been taken")
    |> foreign_key_constraint(:role_id)

  end
end
