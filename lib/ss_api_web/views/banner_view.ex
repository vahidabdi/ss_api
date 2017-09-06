defmodule SsApiWeb.BannerView do
  use SsApiWeb, :view

  alias SsApi.BannerImage

  def render("show.json", %{banner: banner}) do
    %{
      image: SsApiWeb.Endpoint.url <> BannerImage.url({banner.picture, banner}),
      service_id: banner.service_id
    }
  end
end
