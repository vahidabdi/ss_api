defmodule SsApi.Repo.Migrations.RemoveServiceComments do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE social_comments DROP CONSTRAINT social_comments_service_id_fkey"
    alter table(:social_comments) do
      modify :service_id, references(:services, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE social_comments DROP CONSTRAINT social_comments_service_id_fkey"
    alter table(:social_comments) do
      modify :service_id, references(:services, on_delete: :nothing)
    end
  end
end
