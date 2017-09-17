defmodule SsApiWeb.SocialResolver do
  import Ecto.Query
  alias SsApi.{Repo, Social}
  alias SsApi.Social.{User, Comment}

  def list_users(_args, %{context: %{current_user: %{id: id}}}) do
    users = Social.list_social_users
    {:ok, users}
  end
  def list_users(_, _) do
    {:error, "unauthorized"}
  end

  def find_user(%{user_id: user_id}, %{context: %{current_user: %{id: id}}}) do
    user = Social.get_user!(user_id)
    {:ok, user}
  end
  def find_user(_, _) do
    {:error, "unauthorized"}
  end

  def list_comments(%{approved: approved}, %{context: %{current_user: %{id: id}}}) do
    query =
      from c in Comment,
      where: c.approved == ^approved
    comments = Repo.all(query)
    {:ok, comments}
  end
  def list_comments(_args, %{context: %{current_user: %{id: id}}}) do
    comments = Social.list_social_comments
    {:ok, comments}
  end
  def list_comments(_, _) do
    {:error, "unauthorized"}
  end
end
