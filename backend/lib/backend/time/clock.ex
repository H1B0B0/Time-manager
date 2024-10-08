defmodule Backend.Time.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    belongs_to :user, Backend.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :user_id])
    |> validate_required([:status, :time, :user_id])
    |> validate_inclusion(:status, [true, false], message: "must be true or false")
    |> foreign_key_constraint(:user_id, name: "clocks_user_id_fkey")
  end
end
