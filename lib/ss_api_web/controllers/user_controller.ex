defmodule SsApiWeb.UserController do
  use SsApiWeb, :controller
  import Ecto.Query
  plug Guardian.Plug.EnsureAuthenticated, [handler: SsApiWeb.SessionController] when action in [:favourite, :current_user, :current_user_favourites, :remove_service]

  alias SsApi.Repo
  alias SsApi.Social
  alias SsApi.Social.User
  alias SsApi.Vas.Service

  def create(conn, %{"phone_number" => phone_number, "name" => name} = user_params) do
    case Social.find_or_create_user(user_params) do
      nil ->
        conn
        |> put_status(422)
        |> json(%{error: "خطا در ساخت کاربر"})
      _user ->
        token = Enum.take_random(0..9, 6) |> Enum.join("")
        Redix.command(:redix, ["setex", phone_number, "300", token])
        spawn(SsApi.SMS, :send_sms, [name, phone_number, token])
        conn
        |> put_status(:created)
        |> json(%{"status": "ok"})
    end
  end
  def create(conn, _) do
    conn
    |> put_status(422)
    |> json(%{error: "خطا در پارامتر های ارسالی"})
  end

  def current_user(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)

    case Guardian.refresh!(jwt, claims, %{ttl: {1, :year}}) do
      {:ok, new_jwt, _new_claims} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, jwt: new_jwt)
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> render("unauthorized.json", error: "دسترسی ندارید")
    end
  end

  def current_user_favourites(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    q = from u in Social.UserMeta, where: u.user_id == ^user.id and u.favourited == true, select: u.service_id
    service_ids = Repo.all(q)
    q = from s in Service, where: s.id in ^service_ids, preload: [:category, :operator, :type]
    case Repo.all(q) do
      [] ->
        conn
        |> put_status(404)
        |> json(%{"error" => "هیج سرویس در لیست علاقه مندی ها وجود ندارد"})
      services ->
        render(conn, "user_favourites.json", services: services)
    end
  end

  def favourite(conn, %{"service_id" => service_id}) do
    user = Guardian.Plug.current_resource(conn)
    service_id = String.to_integer(service_id)
      case Social.update_or_create_meta(%{user_id: user.id, service_id: service_id, favourited: true}) do
      {:ok, _} ->
        conn
        |> put_status(201)
        |> json(%{status: "ok"})
      _ ->
        conn
        |> put_status(422)
        |> json(%{"error" => "خطا در پارامتر های ورودی"})
    end
  end
  def favourite(conn, _) do
    conn
    |> put_status(422)
    |> json(%{error: "خطا در پارامتر های ارسالی"})
  end

  def remove_service(conn, %{"service_id" => service_id}) do
    user = Guardian.Plug.current_resource(conn)
    service_id = String.to_integer(service_id)
    case Social.find_user_meta(%{user_id: user.id, service_id: service_id}) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{"error" => "favourite not found"})
      m ->
        Social.update_user_meta(m, %{favourited: false})
        conn
        |> put_status(201)
        |> json(%{status: "removed"})
    end
  end
  def remove_service(conn, _) do
    conn
    |> put_status(422)
    |> json(%{error: "خطا در پارامتر های ارسالی"})
  end

  def login(conn, %{"phone_number" => phone_number, "token" => user_token}) do
    case Redix.command(:redix, ["get", phone_number]) do
      {:ok, nil} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "دسترسی ندارید"})
      {:ok, db_token} ->
        if db_token != user_token do
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "دسترسی ندارید"})
        else
          u = Repo.get_by(User, phone_number: phone_number)
          case u do
            nil ->
              conn
              |> put_status(:unauthorized)
              |> json(%{error: "دسترسی ندارید"})
            user ->
              {:ok, jwt, _} = Guardian.encode_and_sign(u)
              conn
              |> put_status(:created)
              |> render("show.json", user: user, jwt: jwt)
          end
        end
    end
  end
  def login(conn, _) do
    conn
    |> put_status(422)
    |> json(%{error: "خطا در پارامتر های ارسالی"})
  end
end
