defmodule SsApiWeb.ServiceController do
  use SsApiWeb, :controller
  import Ecto.Query

  plug Guardian.Plug.EnsureAuthenticated, [handler: SsApiWeb.SessionController] when action in [:comment]

  alias SsApi.Repo
  alias SsApi.Vas
  alias SsApi.Vas.Service
  alias SsApi.Social.Comment
  alias SsApi.Settings

  def action(conn, _) do
    page = conn.params["page"] || 1
    page_size = conn.params["page_size"] || 10
    args = [conn, conn.params, page, page_size]
    apply(__MODULE__, action_name(conn), args)
  end

  def ordered(query) do
    from o in query,
      order_by: [desc: o.is_featured, desc: o.updated_at]
  end

  def index(conn, _params, page, page_size) do
    banners = Settings.list_banners
    res = Vas.get_latest(page: page, page_size: page_size)
    render(conn, "homepage_index.json", banners: banners, final: res)
  end

  def show(conn, %{"id" => id}, _, _) do
    id = String.to_integer(id)
    query = from(s in Service, where: s.id == ^id, lock: "FOR UPDATE")
    res =
      Repo.transaction(fn ->
        service =
          query
          |> preload([:category, :operator, :type])
          |> Repo.one()
          |> Repo.preload(comments: from(c in Comment, where: c.approved == true, preload: :user))
        case service do
          nil ->
            Repo.rollback(:not_found)
          s ->
            service = Ecto.Changeset.change(s, view: s.view + 1)
            Repo.update!(service)
        end
      end)
    case res do
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> json(%{error: "سرویس مورد نظر یافت نشد"})
      {:error, _} ->
        conn
        |> put_status(422)
        |> json(%{error: "خطا در سرور"})
      {:ok, service} ->
        conn
        |> render("show_comments.json", service: service)
    end
  end
  def show(conn, _, _, _) do
    conn
    |> put_status(422)
    |> json(%{"error": "ایراد در پارامتر های ورودی"})
  end

  def search(conn, %{"search" => search}, page, page_size) do
    search_params =
      search
      |> String.trim()
      |> String.replace(~r/\s+/, "|")

    q = from(s in Service,
      where: fragment("weighted_tsv @@ to_tsquery(?)", ^search_params),
      preload: [:category, :operator, :type],
      order_by: fragment("ts_rank(weighted_tsv, to_tsquery(?)) DESC", ^search_params))

    services =
      q
      |> ordered()
      |> Repo.paginate(page: page, page_size: page_size)
    conn
    |> render("index.json", services: services)
  end
  def search(conn, _, _, _) do
    conn
    |> put_status(422)
    |> json(%{"error": "ایراد در پارامتر های ورودی"})
  end

  def likes(conn, %{"service_id" => service_id}, _, _) do
    service_id = String.to_integer(service_id)
    query = from(s in Service, where: s.id == ^service_id, lock: "FOR UPDATE")
    res =
      Repo.transaction(fn ->
        service =
          query
          |> preload([:category, :operator, :type])
          |> Repo.one()
          |> Repo.preload(comments: from(c in Comment, where: c.approved == true))
        service = Ecto.Changeset.change(service, like: service.like + 1)
        Repo.update!(service)
      end)
    case res do
      {:error, _} ->
        conn
        |> put_status(422)
        |> json(%{error: "خطا در سرور"})
      {:ok, service} ->
        conn
        |> render("show_comments.json", service: service)
    end
  end
  def likes(conn, _, _, _) do
    conn
    |> put_status(422)
    |> json(%{"error": "ایراد در پارامتر های ورودی"})
  end

  def comment(conn, %{"service_id" => service_id, "comment" => comment}, _, _) do
    user = Guardian.Plug.current_resource(conn)
    query = from(q in Service, where: q.id == ^service_id)
    service =
      query
      |> preload([:category, :operator, :type])
      |> Repo.one()
    case service do
      nil ->
        render(conn, "error.json")
      s ->
        SsApi.Social.create_comment(%{user_id: user.id, service_id: s.id, comment: comment})
        json(conn, %{"status": "Created"})
    end
  end
  def comment(conn, _, _, _) do
    conn
    |> put_status(422)
    |> json(%{"error": "ایراد در پارامتر های ورودی"})
  end

  def get_type(conn, %{"type_id" => "10001"} = _params, page, page_size) do
    banners = Settings.list_banners
    newest = Vas.get_newest(page: page, page_size: page_size)
    conn
    |> render("index_type.json", services: newest, banners: banners)
  end
  def get_type(conn, %{"type_id" => "10002"} = _params, page, page_size) do
    banners = Settings.list_banners
    hotest = Vas.get_hotest(page: page, page_size: page_size)
    conn
    |> render("index_type.json", services: hotest, banners: banners)
  end
  def get_type(conn, %{"type_id" => type_id} = params, page, page_size) do
    query = build_query(params)
    banners = Settings.list_banners
    services =
      query
      |> preload([:category, :operator, :type])
      |> where(type_id: ^type_id)
      |> ordered()
      |> Repo.paginate(page: page, page_size: page_size)
    conn
    |> render("index_type.json", services: services, banners: banners)
  end
  def get_type(conn, _, _, _) do
    conn
    |> put_status(422)
    |> json(%{"error": "ایراد در پارامتر های ورودی"})
  end

  defp build_query(params) do
    query = from s in Vas.Service
    query
    |> preload([:category, :operator, :type])
    # |> filter_by_tags(Map.get(params, "tags"))
    |> filter_by_operator(Map.get(params, "operator_id"))
    |> filter_by_categories(Map.get(params, "category_id"))
  end

  # defp filter_by_tags(query, nil), do: query
  # defp filter_by_tags(query, ""), do: query
  # defp filter_by_tags(query, tags) do
  #   tags = String.split(tags, ",")
  #   query
  #   |> where(fragment("tags::text[] @> ?::text[]", ^tags))
  # end

  defp filter_by_operator(query, nil), do: query
  defp filter_by_operator(query, ""), do: query
  defp filter_by_operator(query, operator_id) do
    query
    |> where(operator_id: ^operator_id)
  end

  defp filter_by_categories(query, nil), do: query
  defp filter_by_categories(query, ""), do: query
  defp filter_by_categories(query, category_id) do
    query
    |> where(category_id: ^category_id)
  end
end
