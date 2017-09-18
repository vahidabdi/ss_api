defmodule SsApiWeb.Vas.ServiceOperatorResolver do

  alias SsApi.Vas

  def create(%{name: _name} = args, %{context: %{current_user: %{id: _id}}}) do
    case Vas.create_operator(args) do
      {:ok, o} -> {:ok, o}
      _ -> {:error, "error"}
    end
  end
  def create(_args, _info) do
    {:error, "unauthorized"}
  end

  def update(%{operator_id: operator_id} = args, %{context: %{current_user: %{id: _id}}}) do
    case Vas.get_operator(operator_id) do
      nil -> {:erorr, "operator not found"}
      o ->
        case Vas.update_operator(o, args) do
          {:ok, o} -> {:ok, o}
          _ -> {:error, "error"}
        end
    end
  end
  def updaet(_args, _info) do
    {:error, "unauthorized"}
  end

  def list(_, %{context: %{current_user: %{id: _id}}}) do
    {:ok, Vas.list_operators}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

  def find(%{id: id}, %{context: %{current_user: %{id: _id}}}) do
    case Vas.get_operator(id) do
      nil ->
        {:error, "not found"}
      o ->
        {:ok, o}
    end
  end
  def find(_args, _info) do
    {:error, "unauthorized"}
  end
end
