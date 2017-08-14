defmodule SsApi.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :name, :text
      add :eng_name, :text
      add :has_sub_cat, :boolean

      timestamps()
    end

    create unique_index(:types, :name)
  end
end
