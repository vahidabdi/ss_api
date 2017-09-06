defmodule SsApi.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias SsApi.Accounts
  alias SsApi.Accounts.User
  alias SsApi.Social
  alias SsApi.Social.User, as: SUser

  def for_token(user = %User{}), do: {:ok , "User:#{user.id}"}
  def for_token(user = %SUser{}), do: {:ok , "SUser:#{user.id}"}
  def for_token(_), do: {:error , "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Accounts.get_user!(id)}
  def from_token("SUser:" <> id), do: {:ok, Social.get_user!(id)}
  def from_token(_), do: {:error, "Unknown resource type"}

end
