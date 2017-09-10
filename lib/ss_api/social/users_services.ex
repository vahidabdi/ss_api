defmodule SsApi.Social.UserService do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Social.UserService
  alias SsApi.Social.User
  alias SsApi.Vas.Service

  schema "users_services" do
    belongs_to :user, User
    belongs_to :service, Service

    timestamps()
  end

  @doc false
  def changeset(%UserService{} = user_service,  attrs) do
    user_service
    |> cast(attrs, [:user_id, :service_id])
    |> validate_required([:user_id, :service_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:service_id)
    |> unique_constraint(:unique_user_service, name: :unique_user_service)
  end
end
