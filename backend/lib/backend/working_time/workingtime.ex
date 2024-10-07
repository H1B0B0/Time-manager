defmodule Backend.WorkingTime.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
    |> validate_format(:start, ~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/, message: "must be in the format YYYY-MM-DD HH:mm:ss")
    |> validate_format(:end, ~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/, message: "must be in the format YYYY-MM-DD HH:mm:ss")
  end
end
