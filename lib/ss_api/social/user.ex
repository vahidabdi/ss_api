defmodule SsApi.Social.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Social.User


  schema "social_users" do
    field :name, :string
    field :phone_number, :string

    many_to_many :services, SsApi.Vas.Service, join_through: "users_services"

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone_number, :name])
    |> validate_required([:phone_number, :name])
    |> unique_constraint(:phone_number)
  end
end
