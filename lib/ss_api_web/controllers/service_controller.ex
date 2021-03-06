defmodule SsApiWeb.ServiceController do
  use SsApiWeb, :controller
  import Ecto.Query

  plug Guardian.Plug.EnsureAuthenticated, [handler: SsApiWeb.SessionController] when action in [:comment, :likes]

  alias SsApi.Repo
  alias SsApi.Vas
  alias SsApi.Vas.Service
  alias SsApi.Cache
  alias SsApi.Social
  alias SsApi.Social.{Comment, Like}
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

  def index(conn, params, page, page_size) do
    banners = Settings.list_banners
    res = Vas.get_latest(page: page, page_size: page_size, params: params)
    render(conn, "homepage_index.json", banners: banners, final: res)
  end

  def show(conn, %{"id" => id}, _, _) do
    user = Guardian.Plug.current_resource(conn)
    like_by_user = false
    favourite_by_user = false
    {like_by_user, favourite_by_user} =
      case user do
        nil ->
          {false, false}
        user ->
          case Social.find_user_meta(%{user_id: user.id, service_id: id}) do
            nil ->
              {false, false}
            m ->
              {m.liked, m.favourited}
          end
      end
    id = String.to_integer(id)
    %Postgrex.Result{rows: rows} = Ecto.Adapters.SQL.query!(Repo, "SELECT * FROM increment_view($1)", [id])
    [[val]] = rows
    case val do
      true ->
        service =
          from(s in Service, where: s.id == ^id)
          |> preload([:category, :operator, :type])
          |> Repo.one()
          |> Repo.preload(comments: from(c in Comment, where: c.approved == true, preload: :user))
          conn
          |> render("show_comments.json", service: service, like_by_user: like_by_user, favourite_by_user: favourite_by_user)
      false ->
        conn
        |> put_status(404)
        |> json(%{error: "سرویس مورد نظر یافت نشد"})
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
    user = Guardian.Plug.current_resource(conn)
    service_id = String.to_integer(service_id)
    case Social.update_or_create_meta(%{user_id: user.id, service_id: service_id, liked: true}) do
      {:ok, _} ->
        conn
        |> put_status(201)
        |> json(%{status: "ok"})
      _ ->
        conn
        |> put_status(422)
        |> json(%{"error" => "خطا در پارامتر های ورودی"})
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
    type_id = String.to_integer(type_id)
    [t] = Cache.get_types() |> Enum.filter(& &1.id == type_id)
    q = Service |> preload([:category, :operator, :type])
    q1 =
      case Map.get(params, "operator_id") && t.has_operator do
        true -> Vas.filter_by_operator(q, Map.get(params, "operator_id"))
        _ -> q
      end
    q2 =
      case Map.get(params, "category_id") && t.has_sub_cat do
        true -> Vas.filter_by_categories(q1, Map.get(params, "category_id"))
        _ -> q1
      end
    IO.puts("get type: query: #{inspect(q2)}\bparams: #{inspect(params)}")
    banners = Settings.list_banners
    services =
      q2
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
end
