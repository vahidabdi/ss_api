defmodule SsApi.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Social.Comment
  alias SsApi.Social.User
  alias SsApi.Vas.Service

  schema "social_comments" do
    field :comment, :string
    field :approved, :boolean
    belongs_to :user, User
    belongs_to :service, Service

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:comment, :user_id, :service_id, :approved])
    |> validate_required([:comment, :user_id, :service_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:service_id)
  end
end
