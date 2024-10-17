defmodule Backend.Repo.Migrations.AddTeamToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :team_id, references(:teams, on_delete: :nilify_all), null: true
    end

    create index(:users, [:team_id])
  end
end
