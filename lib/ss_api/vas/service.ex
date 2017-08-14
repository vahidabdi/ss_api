defmodule SsApi.Vas.Service do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias SsApi.Vas.{Service, Operator, Type, Category}

  schema "services" do
    field :name, :string
    field :description, :string
    field :help, :string
    field :filename, :string
    field :expire_after, :integer
    field :tags, {:array, :string}
    field :like, :integer
    field :meta, :map
    field :picture, :string
    field :price, :string
    field :run, :integer
    field :view, :integer
    belongs_to :operator, Operator
    belongs_to :type, Type
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(%Service{} = service, attrs) do
    service
    |> cast(attrs, [:name, :description, :help, :tags, :price, :expire_after, :like, :view, :run, :filename, :meta, :type_id, :operator_id, :category_id])
    |> put_unique_filename()
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description, :type_id, :picture])
    |> foreign_key_constraint(:type_id)
    |> foreign_key_constraint(:operator_id)
    |> foreign_key_constraint(:category_id)
    |> unique_constraint(:filename)
  end

  defp put_unique_filename(cs) do
    uuid = UUID.uuid4()
    put_change(cs, :filename, uuid)
  end
end
