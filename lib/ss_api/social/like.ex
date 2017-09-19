defmodule SsApi.Social.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Social.Like
  alias SsApi.Social.User
  alias SsApi.Vas.Service

  schema "user_likes" do
    belongs_to :user, User
    belongs_to :service, Service
  end

  @doc false
  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, [:user_id, :service_id])
    |> validate_required([:user_id, :service_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:service_id)
    |> unique_constraint(:unique_user_like_constraint, name: :unique_user_service_likes)
  end
end
