defmodule SsApi.Schema.Types do

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SsApi.Repo
  use SsApi.Schema.ArcResolver, uploader: SsApi.Picture

  require Logger

  object :session do
    field :token, :string
  end

  object :user do
    field :id, :id
    field :username, :string
  end


  object :service do
    field :id, :id
    field :name, :string
    field :status, :boolean
    field :is_featured, :boolean
    field :activation, :string
    field :deactivation, :string
    field :activation_number, :string
    field :description, :string
    field :help, :string
    field :filename, :string

    field :thumb, :string, resolve: arc_file(:picture, :thumb)
    field :original, :string, resolve: arc_file(:picture, :original)
    field :tags, list_of(:string)
    field :price, :string
    field :tags, :string
    field :like, :integer
    field :run, :integer
    field :view, :integer
    field :type_id, :id
    field :type, :service_type, resolve: assoc(:type)
    field :operator, :operator, resolve: assoc(:operator)
    field :category, :category, resolve: assoc(:category)
  end

  object :category do
    field :id, :id
    field :name, :string
    field :services, list_of(:service), resolve: assoc(:services)
  end

  object :operator do
    field :id, :id
    field :name, :string
    field :services, list_of(:service), resolve: assoc(:services)
  end

  object :service_type do
    field :id, :id
    field :name, :string
    field :eng_name, :string
    field :has_sub_cat, :boolean
    field :count, :integer
    field :services, list_of(:service), resolve: assoc(:services)
  end

  object :banner do
    field :id, :id
    field :picture, :string
    field :service, :service, resolve: assoc(:service)
  end
end
