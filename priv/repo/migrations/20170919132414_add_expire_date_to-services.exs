defmodule :"Elixir.SsApi.Repo.Migrations.AddExpireDateTo-services" do
  use Ecto.Migration

  def change do
    alter table(:services) do
      add :expire_date, :timestamptz
    end

    create index(:services, :expire_date)
  end
end
