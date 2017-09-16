defmodule SsApi.Repo.Migrations.AddApproveToComment do
  use Ecto.Migration

  def change do
    alter table(:social_comments) do
      add :approved, :boolean, null: false, default: false
    end

    create index(:social_comments, :approved)
  end
end
