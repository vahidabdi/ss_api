defmodule SsApi.Repo.Migrations.CreateBanners do
  use Ecto.Migration

  def change do
    create table(:banners) do
      add :picture, :text
      add :order, :integer
      add :filename, :text
      add :service_id, references(:services, on_delete: :delete_all)

      timestamps()
    end

  end
end
