defmodule SsApi.Schema do
  use Absinthe.Schema
  import_types SsApi.Schema.Types

  alias SsApiWeb.SessionResolver

  query do
    @desc "current user"
    field :current_user, :user do
      resolve &SessionResolver.current_user/2
    end
  end
end
