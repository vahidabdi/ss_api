defmodule SsApi.Repo.Migrations.AddAllOperator do
  use Ecto.Migration

  def change do
    execute """
    INSERT INTO operators(id, name, internet_charge, buy_charge, pay_bill, credit, inserted_at, updated_at)
    VALUES(1000, 'ALL', '*1#', '*1#', '*1#', '*1#', current_timestamp, current_timestamp)
    """
  end
end
