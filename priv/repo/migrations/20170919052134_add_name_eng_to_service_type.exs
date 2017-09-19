defmodule SsApi.Repo.Migrations.AddNameEngToServiceType do
  use Ecto.Migration

  def change do
    alter  table(:types) do
      add :name_eng, :text, null: false, default: "name_eng"
    end
  end
end
