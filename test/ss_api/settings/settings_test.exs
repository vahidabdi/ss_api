defmodule SsApi.SettingsTest do
  use SsApi.DataCase

  alias SsApi.Settings

  describe "banners" do
    alias SsApi.Settings.Banner

    @valid_attrs %{picture: "some picture"}
    @update_attrs %{picture: "some updated picture"}
    @invalid_attrs %{picture: nil}

    def banner_fixture(attrs \\ %{}) do
      {:ok, banner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_banner()

      banner
    end

    test "list_banners/0 returns all banners" do
      banner = banner_fixture()
      assert Settings.list_banners() == [banner]
    end

    test "get_banner!/1 returns the banner with given id" do
      banner = banner_fixture()
      assert Settings.get_banner!(banner.id) == banner
    end

    test "create_banner/1 with valid data creates a banner" do
      assert {:ok, %Banner{} = banner} = Settings.create_banner(@valid_attrs)
      assert banner.picture == "some picture"
    end

    test "create_banner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_banner(@invalid_attrs)
    end

    test "update_banner/2 with valid data updates the banner" do
      banner = banner_fixture()
      assert {:ok, banner} = Settings.update_banner(banner, @update_attrs)
      assert %Banner{} = banner
      assert banner.picture == "some updated picture"
    end

    test "update_banner/2 with invalid data returns error changeset" do
      banner = banner_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_banner(banner, @invalid_attrs)
      assert banner == Settings.get_banner!(banner.id)
    end

    test "delete_banner/1 deletes the banner" do
      banner = banner_fixture()
      assert {:ok, %Banner{}} = Settings.delete_banner(banner)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_banner!(banner.id) end
    end

    test "change_banner/1 returns a banner changeset" do
      banner = banner_fixture()
      assert %Ecto.Changeset{} = Settings.change_banner(banner)
    end
  end
end
