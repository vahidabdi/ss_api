defmodule SsApi.Repo.Migrations.AddOperatorFieldToTypes do
  use Ecto.Migration

  def change do
    alter table(:types) do
      add :has_operator, :boolean, default: true
    end
  end
end
