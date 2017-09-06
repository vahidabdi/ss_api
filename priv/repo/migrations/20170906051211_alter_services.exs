defmodule SsApi.Repo.Migrations.AlterServices do
  use Ecto.Migration

  def up do
    RunMode.create_type
    alter table(:services) do
      add :runmode, :runmode, default: "sms", null: false
    end
  end

  def down do
    alter table(:services) do
      remove :runmode
    end
    RunMode.drop_type
  end
end
