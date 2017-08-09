defmodule SsApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SsApi.Accounts.User


  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> put_hash_pass()
  end

  defp put_hash_pass(cs) do
    case cs do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(cs, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        cs
    end
  end
end
