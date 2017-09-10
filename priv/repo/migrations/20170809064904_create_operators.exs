defmodule SsApi.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators) do
      add :name, :text
      add :internet_charge, :text, null: false
      add :buy_charge, :text, null: false
      add :pay_bill, :text, null: false
      add :credit, :text, null: false

      timestamps()
    end

    create unique_index(:operators, :name)
  end
end
