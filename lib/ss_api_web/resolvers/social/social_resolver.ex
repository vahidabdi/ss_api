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
    case Social.get_user(user_id) do
      nil -> {:error, "Not found"}
      user -> {:ok, user}
    end
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

  def find_comment(%{comment_id: comment_id}, %{context: %{current_user: %{id: id}}}) do
    case Social.get_comment(comment_id) do
      nil -> {:error, "comment not found"}
      comment -> {:ok, comment}
    end
  end
  def find_comment(_, _) do
    {:error, "unauthorized"}
  end

  def update_comment(%{comment_id: comment_id, approved: approved}, %{context: %{current_user: %{id: id}}}) do
    case Social.get_comment(comment_id) do
      nil -> {:error, "comment not found"}
      comment ->
        case Social.update_comment(comment, %{approved: approved}) do
          {:ok, comment} -> {:ok, comment}
          {:error, _} -> {:error, "update error"}
        end
    end
  end
  def update_comment(_, _) do
    {:error, "unauthorized"}
  end

  def remove_comment(%{comment_id: comment_id}, %{context: %{current_user: %{id: id}}}) do
    case Social.get_comment(comment_id) do
      nil -> {:error, "comment not found"}
      comment ->
        case Social.delete_comment(comment) do
          {:ok, c} -> {:ok, c}
          {:error, _} -> {:error, "error in delete comment"}
        end
    end
  end
  def remove_comment(_, _) do
    {:error, "unauthorized"}
  end

end