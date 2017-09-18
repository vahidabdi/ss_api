defmodule SsApiWeb.Vas.ServiceCategoryResolver do

  alias SsApi.Vas

  def list(_args, %{context: %{current_user: %{id: id}}}) do
    {:ok, Vas.list_categories}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

  def find(%{id: id}, %{context: %{current_user: %{id: id}}}) do
    case Vas.get_category(id) do
      nil ->
        {:error, "not found"}
      c ->
        {:ok, c}
    end
  end
  def find(_args, _info) do
    {:error, "unauthorized"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    case Vas.create_category(args) do
      {:ok, c} -> {:ok, c}
      _ -> {:error, "wtf"}
    end
  end
  def create(_args, _info) do
    {:error, "unauthorized"}
  end

  def update(%{category_id: category_id} = args, %{context: %{current_user: %{id: _id}}}) do
    case Vas.get_category(category_id) do
      nil -> {:erorr, "category not found"}
      c ->
        case Vas.update_category(c, args) do
          {:ok, c} -> {:ok, c}
          _ -> {:error, "error"}
        end
    end
  end
  def updaet(_args, _info) do
    {:error, "unauthorized"}
  end
end
