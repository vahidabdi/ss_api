defmodule SsApi.Repo.Migrations.UserLikes do
  use Ecto.Migration

  def change do
    create table(:user_likes) do
      add :user_id, references(:social_users, on_delete: :delete_all)
      add :service_id, references(:services, on_delete: :delete_all)
    end

    create index(:user_likes, [:user_id])
    create index(:user_likes, [:service_id])
    create unique_index(:user_likes, [:user_id, :service_id], name: :unique_user_service_likes)
  end
end
