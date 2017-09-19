defmodule SsApi.Query do
  alias SsApi.Vas

  def build_query(params) do
    query = from s in Vas.Service
    query
    |> preload([:category, :operator, :type])
    |> filter_by_operator(Map.get(params, "operator_id"))
    |> filter_by_categories(Map.get(params, "category_id"))
  end

  defp filter_by_operator(query, nil), do: query
  defp filter_by_operator(query, ""), do: query
  defp filter_by_operator(query, operator_id) do
    query
    |> where(operator_id: ^operator_id)
    |> or_where([s], is_nil(s.operator_id))
    |> or_where(operator_id: 1000)
  end

  defp filter_by_categories(query, nil), do: query
  defp filter_by_categories(query, ""), do: query
  defp filter_by_categories(query, category_id) do
    query
    |> where(category_id: ^category_id)
  end
end
