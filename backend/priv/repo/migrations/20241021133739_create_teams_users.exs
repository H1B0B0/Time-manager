defmodule Backend.Repo.Migrations.CreateTeamsUsers do
  use Ecto.Migration

  def change do
    create table(:teams_users) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:teams_users, [:team_id])
    create index(:teams_users, [:user_id])
  end
end
