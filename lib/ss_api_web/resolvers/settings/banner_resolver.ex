defmodule SsApiWeb.Settings.BannerResolver do

  alias SsApi.Settings

  def list(_, %{context: %{current_user: %{id: id}}}) do
    {:ok, Settings.list_banners}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    case Settings.create_banner(args) do
      {:ok, b} -> {:ok, b}
      {:error, x} ->
        IO.inspect(x)
        {:error, "wtf"}
    end
  end
  def create(_args, _info) do
    {:error, "unauthorized"}
  end

  def remove(%{banner_id: banner_id}, %{context: %{current_user: %{id: id}}}) do
    banner = Settings.get_banner!(banner_id)
    case Settings.delete_banner(banner) do
      {:ok, b} -> {:ok, b}
      {:error, x} ->
        IO.inspect(x)
        {:error, "wtf"}
    end
  end
  def remove(_args, _info) do
    {:error, "unauthorized"}
  end
end
