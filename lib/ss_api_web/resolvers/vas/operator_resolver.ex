defmodule SsApiWeb.Vas.ServiceOperatorResolver do

  alias SsApi.Vas

  def create(%{name: name} = args, %{context: %{current_user: %{id: id}}}) do
    case Vas.create_operator(args) do
      {:ok, o} -> {:ok, o}
      _ -> {:error, "error"}
    end
  end
  def create(_args, _info) do
    {:error, "unauthorized"}
  end

  def list(_, %{context: %{current_user: %{id: id}}}) do
    {:ok, Vas.list_operators}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

  def find(%{id: id}, %{context: %{current_user: %{id: id}}}) do
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
