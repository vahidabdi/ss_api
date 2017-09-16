defmodule SsApiWeb.CommentView do
  use SsApiWeb, :view

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      comment: comment.comment,
      user_id: comment.user_id
    }
  end
end
