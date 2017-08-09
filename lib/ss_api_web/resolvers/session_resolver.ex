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

end
