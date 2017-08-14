defmodule SsApiWeb.Vas.ServiceTypeResolver do
  import Ecto.Query
  alias SsApi.{Vas, Repo}

  def list(_args, %{context: %{current_user: %{id: id}}}) do
    types = Vas.list_types()
    service_type_count =
      Enum.map(types, fn t ->
        qq = from q in Vas.Service, where: q.type_id == ^t.id
        co = Repo.aggregate qq, :count, :id
        %{
          name: t.name,
          id: t.id,
          has_sub_cat: t.has_sub_cat,
          eng_name: t.eng_name,
          count: co
        }
      end)
    {:ok, service_type_count}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

  def find(%{id: id}, _info) do
    case Vas.get_type(id) do
      nil ->
        {:error, "not found"}
      t ->
        qq = from q in Vas.Service, where: q.type_id == ^id
        co = Repo.aggregate qq, :count, :id
        res =
          %{
            name: t.name,
            id: t.id,
            has_sub_cat: t.has_sub_cat,
            eng_name: t.eng_name,
            count: co
          }
        {:ok, res}
    end
  end
  def find(_args, _info) do
    {:error, "unauthorized"}
  end

  def count_services(_args, %{context: %{current_user: %{id: id}}}) do
    types = Vas.list_types()
    service_type_count =
      Enum.map(types, fn v ->
        qq = from q in Vas.Service, where: q.type_id == ^v.id
        co = Repo.aggregate qq, :count, :id
        %{name: v.name, id: v.id, count: co}
      end)
    {:ok, service_type_count}
  end
  def count_services(_args, _info) do
    {:error, "unauthorized"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    case Vas.create_type(args) do
      {:ok, t} -> {:ok, t}
      _ -> {:error, "wtf"}
    end
  end
  def create(_args, _info) do
    {:error, "unauthorized"}
  end

end
