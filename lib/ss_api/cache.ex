defmodule SsApi.Cache do
  use GenServer

  @newest %{name: "تازه ها", id: 10001, has_sub_cat: false}
  @hotest %{name: "داغ ترین ها", id: 10002, has_sub_cat: false}

  alias SsApi.Vas

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def show_state do
    GenServer.call(__MODULE__, :show_state)
  end

  def get_categories do
    GenServer.call(__MODULE__, :get_categories)
  end

  def get_operators do
    GenServer.call(__MODULE__, :get_operators)
  end

  def get_types do
    GenServer.call(__MODULE__, :get_types)
  end

  # Callback
  def handle_call(:show_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_categories, _from, state) do
    case Map.get(state, :categories) do
      nil ->
        obj = Vas.list_categories |> Enum.map(&(%{id: &1.id, name: &1.name}))
        new_state = Map.update(state, :categories, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      [] ->
        obj = Vas.list_categories |> Enum.map(&(%{id: &1.id, name: &1.name}))
        new_state = Map.update(state, :categories, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      c ->
        {:reply, c, state}
    end
  end

  def handle_call(:get_operators, _from, state) do
    case Map.get(state, :operators) do
      nil ->
        obj = Vas.list_operators |> Enum.map(&(%{id: &1.id, name: &1.name}))
        new_state = Map.update(state, :operators, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      [] ->
        obj = Vas.list_operators |> Enum.map(&(%{id: &1.id, name: &1.name}))
        new_state = Map.update(state, :operators, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      o ->
        {:reply, o, state}
    end
  end

  def handle_call(:get_types, _from, state) do
    case Map.get(state, :types) do
      nil ->
        obj = Vas.list_types |> Enum.map(&(%{id: &1.id, name: &1.name, has_sub_cat: &1.has_sub_cat}))
        obj = [@newest, @hotest | obj]
        new_state = Map.update(state, :types, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      [] ->
        obj = Vas.list_types |> Enum.map(&(%{id: &1.id, name: &1.name, has_sub_cat: &1.has_sub_cat}))
        obj = [@newest, @hotest | obj]
        new_state = Map.update(state, :types, obj, fn _x -> obj end)
        {:reply, obj, new_state}
      t ->
        {:reply, t, state}
    end
  end

end
