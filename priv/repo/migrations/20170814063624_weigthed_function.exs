defmodule SsApi.Repo.Migrations.WeigthedFunction do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION services_weighted_tsv_trigger() RETURNS trigger AS $$
    BEGIN
      new.weighted_tsv :=
         setweight(to_tsvector('simple', new.name), 'A') ||
         setweight(to_tsvector('simple', array_to_string(new.tags,' '::text)), 'A') ||
         setweight(to_tsvector('simple', new.description), 'B') ||
         setweight(to_tsvector('simple', COALESCE(new.help,'')), 'C') ||
         setweight(to_tsvector('simple', new.activation), 'D') ||
         setweight(to_tsvector('simple', COALESCE(new.deactivation,'')), 'D') ||
         setweight(to_tsvector('simple', COALESCE(new.activation_number,'')), 'D');
      RETURN new;
    END
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER upd_tsvector BEFORE INSERT OR UPDATE
    ON services
    FOR EACH ROW EXECUTE PROCEDURE services_weighted_tsv_trigger();
    """
  end

  def down do
    execute """
    DROP TRIGGER upd_tsvector ON services;
    """
    execute """
    DROP FUNCTION services_weighted_tsv_trigger();
    """
  end
end
