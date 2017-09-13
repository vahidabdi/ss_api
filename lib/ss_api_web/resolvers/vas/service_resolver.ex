defmodule SsApiWeb.Vas.ServiceResolver do

  import Ecto.Query
  alias SsApi.{Vas, Repo}
  alias SsApi.Vas.Service

  def ordered(query) do
    from o in query,
      order_by: [desc: o.is_featured, desc: o.updated_at]
  end

  def latest(args, %{context: %{current_user: %{id: id}}}) do
    query = build_query(args)
    services =
      query
      |> ordered()
      |> Repo.paginate(args)
    {:ok, services.entries}
  end
  def latest(_, _) do
    {:error, "unauthorized"}
  end

  def search(%{search: search} = _args, %{context: %{current_user: %{id: id}}}) do
    search_params =
      search
      |> String.trim()
      |> String.replace(~r/\s+/, "|")

    q = from(s in Service,
      where: fragment("weighted_tsv @@ to_tsquery(?)", ^search_params),
      preload: [:category, :operator, :type, :comments],
      order_by: fragment("ts_rank(weighted_tsv, to_tsquery(?)) DESC", ^search_params))

    services =
      q
      |> ordered()
      |> Repo.paginate()
    {:ok, services.entries}
  end
  def search(_, _) do
    {:error, "unauthorized"}
  end

  def featured(%{type_id: type_id}, %{context: %{current_user: %{id: id}}}) do
    query =
      from q in Vas.Service, where: q.type_id == ^type_id and q.is_featured == true
    services =
      query
      |> where([is_featured: true])
      |> ordered()
      |> Repo.all()
    IO.inspect(services)
    {:ok, services}
  end

  # def find(%{id: id}, %{context: %{current_user: %{id: id}}}) do
  def find(%{id: id}, _info) do
    case Vas.get_service(id) do
      nil -> {:error, "not found"}
      s -> {:ok, s}
    end
  end
  def find(_args, info) do
    IO.inspect(info.context.current_user.id)
    {:error, "unauthorizedsssss"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    case Vas.create_service(args) do
      {:ok, service} ->

        {:ok, service |> Map.put_new(:thumb, SsAPicture)}
      {:error, x} ->
        IO.inspect(x)
        {:error, "wtf"}
    end
  end
  def create(_args, _) do
    {:error, "unauthorized"}
  end


  def update(%{id: service_id} = args, %{context: %{current_user: %{id: id}}}) do
    v = Vas.get_service(service_id)
    case v do
      nil ->
        %{error: "سرویس یافت نشد"}
      _ ->
        case Vas.update_service(v, args) do
          {:error, e} -> {:error, "خطا در اپدیت"}
          x -> x
        end
    end
  end
  def update(_, _) do
    {:error, "unauthorized"}
  end

  def remove(%{id: service_id}, %{context: %{current_user: %{id: id}}}) do
    s = Vas.get_service!(service_id)
    Vas.delete_service(s)
    {:ok, s}
  end
  def remove(_args, _) do
    {:error, "unauthorized"}
  end

  defp build_query(args) do
    query = from s in Vas.Service
    query
    |> filter_by_type(Map.get(args, :type_id))
    |> filter_by_operator(Map.get(args, :operator_id))
    |> filter_by_category(Map.get(args, :category_id))
  end

  defp filter_by_type(query, nil), do: query
  defp filter_by_type(query, ""), do: query
  defp filter_by_type(query, type_id) do
    query
    |> where(type_id: ^type_id)
  end

  defp filter_by_operator(query, nil), do: query
  defp filter_by_operator(query, ""), do: query
  defp filter_by_operator(query, operator_id) do
    query
    |> where(operator_id: ^operator_id)
  end

  defp filter_by_category(query, nil), do: query
  defp filter_by_category(query, ""), do: query
  defp filter_by_category(query, category_id) do
    query
    |> where(category_id: ^category_id)
  end
end
