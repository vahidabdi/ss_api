defmodule SsApiWeb.MetaController do
  use SsApiWeb, :controller

  alias SsApi.Cache

  def index(conn, _params) do
    types = Cache.get_types
    operators = Cache.get_operators
    categories = Cache.get_categories

    json(conn, %{
      types: types,
      categories: categories,
      operators: operators
    })
  end
end
