defmodule SsApi.Repo.Migrations.AddTriggerAfterLike do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION increment_likes_func()
    RETURNS TRIGGER AS $$
    BEGIN
      IF (TG_OP = 'INSERT') THEN
        UPDATE services SET "like" = "like" + 1 WHERE id = NEW.service_id;
        RETURN NEW;
      END IF;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER increment_likes
    AFTER INSERT ON user_likes
    FOR EACH ROW
    EXECUTE PROCEDURE increment_likes_func()
    """
  end

  def down do
    execute """
    DROP TRIGGER IF EXISTS increment_likes ON user_likes;
    """

    execute """
    DROP FUNCTION increment_likes_func();
    """
  end
end
