defmodule SsApi.Repo.Migrations.AddAppToRunMode do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up do
    execute "ALTER TYPE runmode ADD VALUE IF NOT EXISTS 'app'"
  end

  def down do
  end
end
