defmodule Backend.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :category, :string

      timestamps(type: :utc_datetime)
    end
  end
end
