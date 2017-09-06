defmodule SsApiWeb.UserController do
  use SsApiWeb, :controller
  import Ecto.Query
  plug Guardian.Plug.EnsureAuthenticated, [handler: SsApiWeb.SessionController] when action in [:favourite, :current_user, :current_user_favourites]

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
        token = :crypto.strong_rand_bytes(6) |> Base.encode64 |> binary_part(0, 6)
        Redix.command(:redix, ["setex", phone_number, "300", token])
        pid = spawn(SsApi.SMS, :send_sms, [name, phone_number, token])
        IO.inspect(pid)
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
    query = from(q in User, where: q.id == ^user.id, preload: [services: [:category, :operator, :type]])
    case Repo.one(query) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{"error" => "هیج سرویس در لیست علاقه مندی ها وجود ندارد"})
      user ->
        render(conn, "user_favourites.json", services: user.services)
    end
  end

  def favourite(conn, %{"service_id" => service_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from(q in Service, where: q.id == ^service_id, preload: :users)
    case Repo.one(query) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{"error" => "service not found"})
      s ->
        changeset = Ecto.Changeset.change(s) |> Ecto.Changeset.put_assoc(:users, [user])
        Repo.update!(changeset)
        render(conn, "favourites.json")
    end
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
