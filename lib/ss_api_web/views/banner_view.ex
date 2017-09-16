defmodule SsApiWeb.BannerView do
  use SsApiWeb, :view

  @endpoint_url Application.get_env(:ss_api, :endpoint_url)

  alias SsApi.BannerImage

  def render("show.json", %{banner: banner}) do
    %{
      banner1x: @endpoint_url <> BannerImage.url({banner.picture, banner}, :banner1x),
      banner2x: @endpoint_url <> BannerImage.url({banner.picture, banner}, :banner2x),
      banner3x: @endpoint_url <> BannerImage.url({banner.picture, banner}, :banner3x),
      service_id: banner.service_id
    }
  end
end
