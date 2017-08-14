defmodule SsApi.Vas.Operator do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Vas.{Operator, Service}


  schema "operators" do
    field :name, :string
    has_many :services, Service

    timestamps()
  end

  @doc false
  def changeset(%Operator{} = operator, attrs) do
    operator
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
