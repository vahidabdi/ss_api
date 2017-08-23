defmodule SsApi.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias SsApi.Repo

  alias SsApi.Settings.Banner

  @doc """
  Returns the list of banners.

  ## Examples

      iex> list_banners()
      [%Banner{}, ...]

  """
  def list_banners do
    Repo.all(Banner)
  end

  @doc """
  Gets a single banner.

  Raises `Ecto.NoResultsError` if the Banner does not exist.

  ## Examples

      iex> get_banner!(123)
      %Banner{}

      iex> get_banner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_banner!(id), do: Repo.get!(Banner, id)

  @doc """
  Creates a banner.

  ## Examples

      iex> create_banner(%{field: value})
      {:ok, %Banner{}}

      iex> create_banner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_banner(attrs \\ %{}) do
    %Banner{}
    |> Banner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a banner.

  ## Examples

      iex> update_banner(banner, %{field: new_value})
      {:ok, %Banner{}}

      iex> update_banner(banner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_banner(%Banner{} = banner, attrs) do
    banner
    |> Banner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Banner.

  ## Examples

      iex> delete_banner(banner)
      {:ok, %Banner{}}

      iex> delete_banner(banner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_banner(%Banner{} = banner) do
    Repo.delete(banner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking banner changes.

  ## Examples

      iex> change_banner(banner)
      %Ecto.Changeset{source: %Banner{}}

  """
  def change_banner(%Banner{} = banner) do
    Banner.changeset(banner, %{})
  end
end
