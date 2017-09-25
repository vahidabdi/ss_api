defmodule SsApi.Vas.Service do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias SsApi.Vas.{Service, Operator, Type, Category}

  schema "services" do
    field :name, :string
    field :description, :string
    field :help, :string
    field :status, :boolean
    field :is_featured, :boolean
    field :activation, :string
    field :deactivation, :string
    field :activation_number, :string
    field :filename, :string
    field :expire_date, :utc_datetime
    field :tags, {:array, :string}
    field :like, :integer
    field :meta, :map
    field :picture, SsApi.Picture.Type
    field :price, :string
    field :run, :integer
    field :view, :integer
    field :runmode, RunMode
    field :thumb1x_url, :string, virtual: true
    field :thumb2x_url, :string, virtual: true
    field :thumb3x_url, :string, virtual: true
    field :banner1x_url, :string, virtual: true
    field :banner2x_url, :string, virtual: true
    field :banner3x_url, :string, virtual: true
    belongs_to :operator, Operator
    belongs_to :type, Type
    belongs_to :category, Category

    many_to_many :users, SsApi.Social.User, join_through: "user_meta"
    has_many :comments, SsApi.Social.Comment
    timestamps()
  end

  @doc false
  def changeset(%Service{} = service, attrs) do
    service
    |> cast(attrs, [:name, :description, :status, :is_featured, :activation, :deactivation, :activation_number, :help, :tags, :price, :expire_date, :like, :view, :run, :filename, :meta, :type_id, :operator_id, :category_id, :runmode])
    |> put_unique_filename()
    |> unique_constraint(:filename)
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description, :type_id, :activation, :runmode])
    |> foreign_key_constraint(:type_id)
    |> foreign_key_constraint(:operator_id)
    |> foreign_key_constraint(:category_id)
  end

  def update_changeset(%Service{} = serivce, attrs) do
    serivce
    |> cast(attrs, [:name, :description, :status, :is_featured, :activation, :deactivation, :activation_number, :help, :tags, :price, :expire_date, :like, :view, :run, :meta, :type_id, :operator_id, :category_id, :runmode])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description, :type_id, :activation, :runmode])
    |> foreign_key_constraint(:type_id)
    |> foreign_key_constraint(:operator_id)
    |> foreign_key_constraint(:category_id)
  end

  def update_picture(%Service{} = service, attrs) do
    service
    |> cast_attachments(attrs, [:picture])
  end

  defp put_unique_filename(cs) do
    uuid = UUID.uuid4()
    put_change(cs, :filename, uuid)
  end
end
