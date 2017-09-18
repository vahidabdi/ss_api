defmodule SsApi.Vas.Operator do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Vas.{Operator, Service}


  schema "operators" do
    field :name, :string
    field :internet_charge, :string, default: "*1#"
    field :buy_charge, :string, default: "*1#"
    field :pay_bill, :string, default: "*1#"
    field :credit, :string, default: "*1#"

    has_many :services, Service

    timestamps()
  end

  @doc false
  def changeset(%Operator{} = operator, attrs) do
    operator
    |> cast(attrs, [:name, :internet_charge, :buy_charge, :pay_bill, :credit])
    |> validate_required([:name, :internet_charge, :buy_charge, :pay_bill, :credit])
    |> unique_constraint(:name)
  end
end
