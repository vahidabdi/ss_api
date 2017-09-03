defmodule SsApi.Settings.Banner do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias SsApi.Settings.Banner
  alias SsApi.Vas.Service
  alias SsApi.BannerImage

  schema "banners" do
    field :picture, BannerImage.Type
    field :filename, :string
    field :order, :integer
    belongs_to :service, Service

    timestamps()
  end

  @doc false
  def changeset(%Banner{} = banner, attrs) do
    banner
    |> cast(attrs, [:service_id, :order])
    |> put_unique_filename()
    |> unique_constraint(:filename)
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:picture, :service_id])
    |> foreign_key_constraint(:service_id)
  end

  defp put_unique_filename(cs) do
    uuid = UUID.uuid4()
    put_change(cs, :filename, uuid)
  end
end
