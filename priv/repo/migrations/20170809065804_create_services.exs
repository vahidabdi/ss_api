defmodule SsApi.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :text, null: false
      add :description, :text, null: false
      add :status, :boolean, default: true
      add :is_featured, :boolean, default: false
      add :help, :text
      add :picture, :text, null: false
      add :activation, :text, null: false
      add :deactivation, :text
      add :activation_number, :text
      add :tags, {:array, :text}
      add :price, :text
      add :expire_after, :integer
      add :like, :integer, default: 0
      add :view, :integer, default: 0
      add :run, :integer, default: 0
      add :filename, :text, null: false
      add :meta, :map
      add :operator_id, references(:operators, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing), null: false
      add :category_id, references(:categories, on_delete: :nothing)
      add :weighted_tsv, :tsvector

      timestamps()
    end

    create index(:services, :operator_id)
    create index(:services, :type_id)
    create index(:services, :category_id)
    create index(:services, :is_featured)
    create index(:services, :tags, using: :gin)
    create index(:services, :weighted_tsv, using: :gin)
    create unique_index(:services, :filename)
  end
end
