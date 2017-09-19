defmodule SsApi.Repo.Migrations.ModifyUserLikes do
  use Ecto.Migration

  def change do
    rename table(:user_likes), to: table(:user_meta)
    alter table(:user_meta) do
      add :liked, :boolean, null: false, default: false
      add :favourited, :boolean, null: false, default: false
    end
  end
end
