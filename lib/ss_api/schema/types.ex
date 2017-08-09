defmodule SsApi.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :username, :string
  end
end
