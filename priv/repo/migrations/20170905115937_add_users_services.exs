defmodule StarSquare.Repo.Migrations.AddUsersServices do
  use Ecto.Migration

  def change do
    create table(:users_services) do
      add :user_id, references(:social_users, on_delete: :delete_all)
      add :service_id, references(:services, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users_services, [:user_id, :service_id], name: :unique_user_service)
  end
end
