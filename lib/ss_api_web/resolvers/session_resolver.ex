defmodule SsApiWeb.SessionResolver do
  alias SsApi.Accounts
  alias SsApi.Accounts.User

  def current_user(_, %{context: %{current_user: %{id: id}}}) do
    case Accounts.get_user(id) do
      nil ->
        {:ok, nil}
      user ->
        {:ok, user}
    end
  end
  def current_user(_, _) do
    {:error, %{message: "Unauthorized", status: 401}}
  end

  def login(%{username: username, password: passwrod}, _) do
    case Accounts.get_user_by_username(username) do
      nil -> {:error, "user not found"}
      u ->
        case Comeonin.Bcrypt.checkpw(passwrod, u.password_hash) do
          true ->
            {:ok, jwt, _} = Guardian.encode_and_sign(u)
            {:ok, %{token: jwt}}
          _ -> {:error, %{message: "Unauthorized", status: 401}}
        end
    end
  end
end
