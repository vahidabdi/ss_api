defmodule SsApi.Repo.Migrations.CreateDailyReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :report_date, :date, null: false
      add :type_id, references(:types, on_delete: :delete_all)
      add :views, :integer, null: false, default: 0
      add :runs, :integer, null: false, default: 0
    end

    create unique_index(:reports , [:report_date, :type_id], name: :unique_daily_report)
  end
end
