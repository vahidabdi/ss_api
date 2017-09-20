defmodule SsApi.Schema do
  use Absinthe.Schema

  import_types Absinthe.Plug.Types
  import_types SsApi.Schema.Types

  alias SsApiWeb.SessionResolver
  alias SsApiWeb.Vas.ServiceResolver
  alias SsApiWeb.Vas.ServiceTypeResolver
  alias SsApiWeb.Vas.ServiceCategoryResolver
  alias SsApiWeb.Vas.ServiceOperatorResolver
  alias SsApiWeb.SocialResolver
  alias SsApiWeb.Settings.BannerResolver

  query do
    @desc "current user"
    field :current_user, :user do
      resolve &SessionResolver.current_user/2
    end

    # Service
    @desc "latest services"
    field :latest_services, list_of(:service) do
      arg :page, :integer
      arg :page_size, :integer
      arg :type_id, :id
      arg :category_id, :id
      arg :operator_id, :id
      resolve &ServiceResolver.latest/2
    end

    @desc "search"
    field :search, list_of(:service) do
      arg :search, non_null(:string)

      resolve &ServiceResolver.search/2
    end

    @desc "featured services"
    field :featured_services, list_of(:service) do
      arg :type_id, non_null(:id)
      arg :page, :integer
      arg :page_size, :integer

      resolve &ServiceResolver.featured/2
    end

    @desc "get service"
    field :service, :service do
      arg :id, non_null(:id)

      resolve &ServiceResolver.find/2
    end

    # Service Type
    @desc "get service types"
    field :service_types, list_of(:service_type) do
      resolve &ServiceTypeResolver.list/2
    end

    @desc "get service type"
    field :service_type, :service_type do
      arg :id, non_null(:id)
      resolve &ServiceTypeResolver.find/2
    end

    # Category
    @desc "list categories"
    field :categories, list_of(:category) do
      resolve &ServiceCategoryResolver.list/2
    end

    @desc "get category"
    field :category, :category do
      arg :id, non_null(:id)
      resolve &ServiceCategoryResolver.find/2
    end

    # Operator
    @desc "list operators"
    field :operators, list_of(:operator) do
      resolve &ServiceOperatorResolver.list/2
    end

    @desc "get operator"
    field :operator, :operator do
      arg :id, non_null(:id)
      resolve &ServiceOperatorResolver.find/2
    end

    # Banner
    @desc "list banners"
    field :banners, list_of(:banner) do
      resolve &BannerResolver.list/2
    end

    # Social
    @desc "list users"
    field :social_users, list_of(:social_user) do
      arg :page, :integer
      arg :page_size, :integer

      resolve &SocialResolver.list_users/2
    end

    @desc "find social user"
    field :social_user, :social_user do
      arg :user_id, non_null(:id)
      resolve &SocialResolver.find_user/2
    end

    @desc "list comments"
    field :comments, list_of(:comment) do
      arg :approved, :boolean
      arg :page, :integer
      arg :page_size, :integer

      resolve &SocialResolver.list_comments/2
    end

    @desc "get comment"
    field :comment, :comment do
      arg :comment_id, :id

      resolve &SocialResolver.find_comment/2
    end
  end

  mutation do
    @desc "user login"
    field :login, type: :session do
      arg :username, non_null(:string)
      arg :password, non_null(:string)

      resolve &SessionResolver.login/2
    end

    @desc "service creation"
    field :service, type: :service do
      arg :name, non_null(:string)
      arg :description, non_null(:string)
      arg :runmode, non_null(:string)
      arg :status, :boolean
      arg :is_featured, :boolean
      arg :activation, non_null(:string)
      arg :deactivation, :string
      arg :activation_number, :string
      arg :help, :string
      arg :expire_after, :string
      arg :price, :string
      arg :tags, list_of(:string)
      arg :picture, :upload
      arg :type_id, non_null(:id)
      arg :category_id, :id
      arg :operator_id, :id

      resolve &ServiceResolver.create/2
    end

    @desc "update service"
    field :update_service, type: :service do
      arg :id, non_null(:id)
      arg :name, :string
      arg :description, :string
      arg :status, :boolean
      arg :is_featured, :boolean
      arg :activation, :string
      arg :deactivation, :string
      arg :activation_number, :string
      arg :help, :string
      arg :expire_after, :string
      arg :price, :string
      arg :tags, list_of(:string)
      arg :picture, :upload
      arg :type_id, :id
      arg :category_id, :id
      arg :operator_id, :id
      arg :runmode, :string

      resolve &ServiceResolver.update/2
    end

    @desc "remove service"
    field :remove_service, type: :service do
      arg :id, non_null(:id)

      resolve &ServiceResolver.remove/2
    end

    @desc "service type creation"
    field :service_type, type: :service_type do
      arg :name, non_null(:string)
      arg :name_eng, non_null(:string)
      arg :has_sub_cat, :boolean
      arg :has_operator, :boolean

      resolve &ServiceTypeResolver.create/2
    end

    @desc "update service type"
    field :update_type, type: :service_type do
      arg :type_id, non_null(:id)
      arg :name, non_null(:string)
      arg :name_eng, non_null(:string)
      arg :has_sub_cat, :boolean
      arg :has_operator, :boolean

      resolve &ServiceTypeResolver.update/2
    end

    @desc "service category creation"
    field :service_category, type: :category do
      arg :name, non_null(:string)

      resolve &ServiceCategoryResolver.create/2
    end

    @desc "update service category"
    field :update_category, type: :category do
      arg :category_id, non_null(:id)
      arg :name, non_null(:string)

      resolve &ServiceCategoryResolver.update/2
    end

    @desc "operator creation"
    field :operator, type: :operator do
      arg :name, non_null(:string)
      arg :internet_charge, non_null(:string)
      arg :buy_charge, non_null(:string)
      arg :pay_bill, non_null(:string)
      arg :credit, non_null(:string)

      resolve &ServiceOperatorResolver.create/2
    end

    @desc "update operator"
    field :update_operator, type: :operator do
      arg :operator_id, non_null(:id)
      arg :name, non_null(:string)
      arg :internet_charge, non_null(:string)
      arg :buy_charge, non_null(:string)
      arg :pay_bill, non_null(:string)
      arg :credit, non_null(:string)

      resolve &ServiceOperatorResolver.update/2
    end

    @desc "banner creation"
    field :banner, type: :banner do
      arg :picture, non_null(:upload)
      arg :service_id, non_null(:id)

      resolve &BannerResolver.create/2
    end

    @desc "remove banner"
    field :remove_banner, type: :banner do
      arg :banner_id, non_null(:id)

      resolve &BannerResolver.remove/2
    end

    @desc "update comment"
    field :update_comment, type: :comment do
      arg :comment_id, non_null(:id)
      arg :approved, non_null(:boolean)

      resolve &SocialResolver.update_comment/2
    end

    @desc "remove comment"
    field :remove_comment, type: :comment do
      arg :comment_id, non_null(:id)

      resolve &SocialResolver.remove_comment/2
    end
  end
end
