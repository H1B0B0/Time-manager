defmodule YourApp.Repo.Migrations.AddRoleIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing), null: false, default: 1
    end

    create index(:users, [:role_id])
  end
end
