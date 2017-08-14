defmodule SsApi.Vas.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Vas.{Category, Service}


  schema "categories" do
    field :name, :string
    has_many :services, Service

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
