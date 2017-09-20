defmodule SsApi.Repo.Migrations.IncrementServiceView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION increment_view(service_id Integer)
    RETURNS BOOLEAN AS $$
      DECLARE my_type_id Integer;
    BEGIN
      UPDATE services SET view = view + 1 WHERE id = service_id RETURNING type_id INTO my_type_id;

      IF FOUND THEN
        INSERT INTO reports as r
          (views, type_id, report_date)
        VALUES
          (1, my_type_id, CURRENT_DATE)
        ON
          CONFLICT (report_date, type_id)
        DO UPDATE SET
          views = r.views + 1;
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
    END;
    $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute """
    DROP FUNCTION IF EXISTS increment_view(service_id Integer);
    """
  end
end
