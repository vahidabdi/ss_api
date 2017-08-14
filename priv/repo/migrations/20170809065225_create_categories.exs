defmodule SsApi.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :text

      timestamps()
    end

    create unique_index(:categories, :name)
  end
end
