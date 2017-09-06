defmodule SsApi.Vas do
  import Ecto.Query, warn: false
  alias SsApi.Repo
  alias SsApi.Cache
  alias SsApi.Vas.Operator
  alias SsApi.Vas.Type
  alias SsApi.Vas.Category
  alias SsApi.Vas.Service

  def ordered(query) do
    from o in query,
      order_by: [desc: o.updated_at]
  end

  def get_hotest(opts \\ []) do
    services =
      from(s in Service, order_by: s.view, limit: 10)
      |> preload([:operator, :type, :category])
      |> ordered()
      |> Repo.paginate(opts)
    services.entries
  end

  def get_newest(opts \\ []) do
    services =
      from(s in Service, order_by: [desc: s.updated_at], limit: 10)
      |> preload([:operator, :type, :category])
      |> ordered()
      |> Repo.paginate(opts)
    services.entries
  end

  def get_latest(opts \\ []) do
    types = Cache.get_types |>
    Enum.map(fn type ->
      services =
        from(q in Service, where: q.type_id == ^type.id)
        |> preload([:operator, :type, :category])
        |> ordered()
        |> Repo.paginate(opts)
      %{type_id: type.id, "#{type.name}": services.entries}
    end)
  end

  def list_operators do
    Repo.all(Operator)
  end

  def get_operator!(id), do: Repo.get!(Operator, id)

  def get_operator(id), do: Repo.get(Operator, id)

  def create_operator(attrs \\ %{}) do
    %Operator{}
    |> Operator.changeset(attrs)
    |> Repo.insert()
  end

  def update_operator(%Operator{} = operator, attrs) do
    operator
    |> Operator.changeset(attrs)
    |> Repo.update()
  end

  def delete_operator(%Operator{} = operator) do
    Repo.delete(operator)
  end

  def change_operator(%Operator{} = operator) do
    Operator.changeset(operator, %{})
  end

  def list_types do
    Repo.all(Type)
  end

  def get_type!(id), do: Repo.get!(Type, id)

  def get_type(id), do: Repo.get(Type, id)

  def create_type(attrs \\ %{}) do
    %Type{}
    |> Type.changeset(attrs)
    |> Repo.insert()
  end

  def update_type(%Type{} = type, attrs) do
    type
    |> Type.changeset(attrs)
    |> Repo.update()
  end

  def delete_type(%Type{} = type) do
    Repo.delete(type)
  end

  def change_type(%Type{} = type) do
    Type.changeset(type, %{})
  end

  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def get_category(id), do: Repo.get(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def list_services do
    Repo.all(Service)
  end

  def get_service!(id), do: Repo.get!(Service, id)

  def get_service(id), do: Repo.get(Service, id)

  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  def update_service(%Service{} = service, attrs) do
    service
    |> Service.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  def change_service(%Service{} = service) do
    Service.changeset(service, %{})
  end
end
