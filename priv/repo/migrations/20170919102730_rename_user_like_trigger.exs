defmodule SsApi.Repo.Migrations.RenameUserLikeTrigger do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION increment_likes_meta()
    RETURNS TRIGGER AS $$
    BEGIN
      IF (TG_OP = 'INSERT') THEN
        IF NEW.liked = true THEN
          UPDATE services SET "like" = "like" + 1 WHERE id = NEW.service_id;
        END IF;
        RETURN NEW;
      END IF;
      IF (TG_OP = 'UPDATE') THEN
        IF OLD.liked = false and NEW.liked = true THEN
          UPDATE services SET "like" = "like" + 1 WHERE id = NEW.service_id;
        END IF;
        RETURN NEW;
      END IF;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER increment_like
    AFTER INSERT ON user_meta
    FOR EACH ROW
    EXECUTE PROCEDURE increment_likes_meta()
    """
  end

  def down do
    execute """
    DROP TRIGGER IF EXISTS increment_like ON user_meta;
    """

    execute """
    DROP FUNCTION increment_likes_meta();
    """
  end
end
