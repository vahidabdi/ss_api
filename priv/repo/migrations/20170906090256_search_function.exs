defmodule SsApi.Repo.Migrations.SearchFunction do
  use Ecto.Migration

  def change do
    execute """
      CREATE OR REPLACE FUNCTION article_search(term varchar)
      RETURNS table(id int, title varchar, slug varchar, display_date date, tags varchar[], rank real, introduction text)
      AS $$
        SELECT ar.id, ar.title, ar.slug, ar.display_date, ar.tags,
          ts_rank_cd(search_vector, search_query, 32) AS rank,
          ts_headline('english',
            CONCAT(introduction,' ',main_body),
            search_query,
            'StartSel=<mark>,StopSel=</mark>,MinWords=50,MaxWords=100'
          ) AS introduction
        FROM articles ar
          INNER JOIN (
            SELECT
              ts_rewrite(
                plainto_tsquery(term),
                CONCAT('SELECT * FROM aliases WHERE plainto_tsquery(''',term,''') @> t')
              ) search_query
          ) sq ON ar.search_vector @@ search_query
        WHERE ar.publish_at IS NOT NULL AND ar.static = FALSE
        ORDER BY rank DESC;
    $$ language SQL;
    """
  end
end
