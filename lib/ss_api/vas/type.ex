defmodule SsApi.Vas.Type do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Vas.{Type, Service}


  schema "types" do
    field :name, :string
    field :has_sub_cat, :boolean
    field :has_operator, :boolean
    has_many :services, Service

    timestamps()
  end

  @doc false
  def changeset(%Type{} = type, attrs) do
    type
    |> cast(attrs, [:name, :has_sub_cat, :has_operator])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
