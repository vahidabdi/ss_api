defmodule SsApi.Repo.Migrations.CreateSocialComments do
  use Ecto.Migration

  def change do
    create table(:social_comments) do
      add :comment, :text
      add :user_id, references(:social_users, on_delete: :nothing)
      add :service_id, references(:services, on_delete: :nothing)

      timestamps()
    end

    create index(:social_comments, [:user_id])
    create index(:social_comments, [:service_id])
  end
end
