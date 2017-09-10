defmodule SsApiWeb.BannerView do
  use SsApiWeb, :view

  alias SsApi.BannerImage

  def render("show.json", %{banner: banner}) do
    %{
      banner1x: SsApiWeb.Endpoint.url <> BannerImage.url({banner.picture, banner}, :banner1x),
      banner2x: SsApiWeb.Endpoint.url <> BannerImage.url({banner.picture, banner}, :banner2x),
      banner3x: SsApiWeb.Endpoint.url <> BannerImage.url({banner.picture, banner}, :banner3x),
      service_id: banner.service_id
    }
  end
end
