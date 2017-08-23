defmodule SsApi.Settings.Banner do
  use Ecto.Schema
  import Ecto.Changeset

  alias SsApi.Settings.Banner
  alias SsApi.Vas.Service

  schema "banners" do
    field :picture, :string
    field :order, :integer
    belongs_to :service, Service

    timestamps()
  end

  @doc false
  def changeset(%Banner{} = banner, attrs) do
    banner
    |> cast(attrs, [:picture, :service_id])
    |> validate_required([:picture, :service_id])
    |> foreign_key_constraint(:service_id)
  end
end
