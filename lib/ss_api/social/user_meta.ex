defmodule SsApi.Social.UserMeta do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Social.UserMeta
  alias SsApi.Social.User
  alias SsApi.Vas.Service

  schema "user_meta" do
    field :liked, :boolean
    field :favourited, :boolean
    belongs_to :user, User
    belongs_to :service, Service
  end

  @doc false
  def changeset(%UserMeta{} = user_meta, attrs) do
    user_meta
    |> cast(attrs, [:user_id, :service_id, :liked, :favourited])
    |> validate_required([:user_id, :service_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:service_id)
    |> unique_constraint(:unique_user_like_constraint, name: :unique_user_service_likes)
  end
end
