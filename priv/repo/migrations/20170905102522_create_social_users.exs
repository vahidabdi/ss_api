defmodule SsApi.Repo.Migrations.CreateSocialUsers do
  use Ecto.Migration

  def change do
    create table(:social_users) do
      add :phone_number, :text
      add :name, :text

      timestamps(type: :timestamptz)
    end

    create unique_index(:social_users, [:phone_number])
  end
end
