defmodule Backend.Repo.Migrations.AddUserIdToWorkingtime do
  use Ecto.Migration

  def change do
    alter table(:workingtime) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:workingtime, [:user_id])
  end
end
