defmodule SsApi.Schema.Types do

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SsApi.Repo
  use SsApi.Schema.ArcResolver, uploader: SsApi.Picture

  require Logger


  scalar :date_me, description: "ISO8601 time" do
    parse &parse_date(&1.report_date)
    serialize &Date.to_string(&1)
  end

  def parse_date(value) do
    IO.inspect value
    case Date.from_iso8601(value) do
      {:ok, val, _} -> {:ok, val}
      {:error, _} -> :error
    end
  end


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
    field :thumb1x, :string, resolve: arc_file(:picture, :thumb1x)
    field :thumb2x, :string, resolve: arc_file(:picture, :thumb2x)
    field :thumb3x, :string, resolve: arc_file(:picture, :thumb3x)
    field :banner1x, :string, resolve: arc_file(:picture, :banner1x)
    field :banner2x, :string, resolve: arc_file(:picture, :banner2x)
    field :banner3x, :string, resolve: arc_file(:picture, :banner3x)
    field :original, :string, resolve: arc_file(:picture, :original)
    field :tags, list_of(:string)
    field :price, :string
    field :like, :integer
    field :expire_after, :string
    field :run, :integer
    field :view, :integer
    field :type_id, :id
    field :operator_id, :id
    field :category_id, :id
    field :runmode, :string
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
    field :internet_charge, :string
    field :buy_charge, :string
    field :pay_bill, :string
    field :credit, :string
    field :services, list_of(:service), resolve: assoc(:services)
  end

  object :service_type do
    field :id, :id
    field :name, :string
    field :name_eng, :string
    field :has_sub_cat, :boolean
    field :has_operator, :boolean
    field :count, :integer
    field :services, list_of(:service), resolve: assoc(:services)
  end

  object :banner do
    field :id, :id
    field :banner1x, :string, resolve: arc_file(SsApi.BannerImage, :picture, :banner1x)
    field :banner2x, :string, resolve: arc_file(SsApi.BannerImage, :picture, :banner2x)
    field :banner3x, :string, resolve: arc_file(SsApi.BannerImage, :picture, :banner3x)
    field :original, :string, resolve: arc_file(SsApi.BannerImage, :picture, :original)
    field :service, :service, resolve: assoc(:service)
  end

  object :social_user do
    field :id, :id
    field :name, :string
    field :phone_number, :string
  end

  object :comment do
    field :id, :id
    field :comment, :string
    field :approved, :boolean
    field :user, :social_user, resolve: assoc(:user)
    field :service, :service, resolve: assoc(:service)
  end

  object :reports do
    field :id, :id
    field :report_date, :date_me
    field :views, :integer
    field :type, :service_type, resolve: assoc(:type)
  end
end
