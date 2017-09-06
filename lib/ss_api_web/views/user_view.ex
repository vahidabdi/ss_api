defmodule SsApiWeb.UserView do
  use SsApiWeb, :view

  alias SsApiWeb.ServiceView

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      user: render_one(user, __MODULE__, "user.json"),
      access_token: jwt
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      phone_number: user.phone_number,
      name: user.name
    }
  end

  def render("unauthenticated.json", _) do
    %{
      "error": "دسترسی ندارید"
    }
  end

  def render("user_favourites.json", %{services: services}) do
    %{
      services: render_many(services, ServiceView, "show.json")
    }
  end

  def render("favourites.json", _) do
    %{"status": "added"}
  end
end
