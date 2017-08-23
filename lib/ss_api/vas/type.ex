defmodule SsApi.Vas.Type do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Vas.{Type, Service}


  schema "types" do
    field :eng_name, :string
    field :name, :string
    field :has_sub_cat, :boolean
    has_many :services, Service

    timestamps()
  end

  @doc false
  def changeset(%Type{} = type, attrs) do
    type
    |> cast(attrs, [:name, :eng_name, :has_sub_cat])
    |> validate_required([:name, :eng_name])
    |> unique_constraint(:name)
  end
end
