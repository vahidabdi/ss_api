defmodule SsApiWeb.Vas.ServiceResolver do

  import Ecto.Query
  alias SsApi.{Vas, Repo}

  def latest(args, %{context: %{current_user: %{id: id}}}) do
    query = build_query(args)
    services =
      query
      |> Repo.paginate(args)
    {:ok, services.entries}
  end
  def latest(_, _) do
    {:error, "unauthorized"}
  end

  def list(_args, %{context: %{current_user: %{id: id}}}) do
    {:ok, Vas.list_services}
  end
  def list(_, _) do
    {:error, "unauthorized"}
  end

  def find(%{id: id}, %{context: %{current_user: %{id: id}}}) do
    case Vas.get_service(id) do
      nil -> {:error, "not found"}
      s -> {:ok, s}
    end
  end
  def find(_args, _info) do
    {:error, "unauthorized"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    case Vas.create_service(args) do
      {:ok, service} -> {:ok, service}
      {:error, x} ->
        IO.inspect(x)
        {:error, "wtf"}
    end
  end
  def create(_args, _) do
    {:error, "unauthorized"}
  end

  defp build_query(args) do
    query = from s in Vas.Service
    query
    |> filter_by_type(Map.get(args, "type_id"))
    |> filter_by_operator(Map.get(args, "operator_id"))
    |> filter_by_category(Map.get(args, "category_id"))
  end

  defp filter_by_type(query, nil), do: query
  defp filter_by_type(query, ""), do: query
  defp filter_by_type(query, type_id) do
    query
    |> where(operator_id: ^type_id)
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
