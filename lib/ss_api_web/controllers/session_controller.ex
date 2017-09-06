defmodule SsApiWeb.SessionController do
  use SsApiWeb, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render("unauthenticated.json")
  end
end
