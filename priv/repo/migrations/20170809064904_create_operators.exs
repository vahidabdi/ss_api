defmodule SsApi.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators) do
      add :name, :text

      timestamps()
    end

    create unique_index(:operators, :name)
  end
end
