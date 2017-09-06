defmodule SsApiWeb.ServiceView do
  use SsApiWeb, :view

  alias SsApiWeb.BannerView
  alias SsApiWeb.CommentView
  alias SsApi.Picture

  def render("index.json", %{services: services}) do
    %{
      services: render_many(services, __MODULE__, "show.json"),
    }
  end

  def render("homepage_index.json", %{final: final, banners: banners}) do
    IO.inspect(final)
    final =
      final
      |> Enum.map(fn m ->
        {type_id, new_map} = Map.pop(m, :type_id)
        [service_key|_] = Map.keys(new_map)
        service_val = Map.get(new_map, service_key)
        %{
          type_id: type_id,
          "#{service_key}": render_many(service_val, __MODULE__, "show.json")
        }
      end)
    %{
      all_services: final,
      banners: render_many(banners, BannerView, "show.json")
    }
  end

  def render("show.json", %{service: service}) do
    %{
      id: service.id,
      name: service.name,
      description: service.description,
      activation: service.activation,
      deactivation: service.deactivation,
      activation_number: service.activation_number,
      help: service.help,
      category: (service.category && service.category.name),
      category_id: service.category_id,
      type: service.type.name,
      type_id: service.type_id,
      operator: (service.operator && service.operator.name),
      operator_id: service.operator_id,
      thumb: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb),
      thumb1x: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb1x),
      thumb2x: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb2x),
      like: service.like,
      view: service.view,
      tags: service.tags,
      price: service.price,
      runmode: service.runmode
    }
  end

  def render("show_comments.json", %{service: service}) do
    %{
      id: service.id,
      name: service.name,
      description: service.description,
      activation: service.activation,
      deactivation: service.deactivation,
      activation_number: service.activation_number,
      help: service.help,
      category: (service.category && service.category.name),
      category_id: service.category_id,
      type: service.type.name,
      type_id: service.type_id,
      operator: (service.operator && service.operator.name),
      operator_id: service.operator_id,
      thumb: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb),
      thumb1x: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb1x),
      thumb2x: SsApiWeb.Endpoint.url <> Picture.url({service.picture, service}, :thumb2x),
      like: service.like,
      view: service.view,
      tags: service.tags,
      price: service.price,
      runmode: service.runmode,
      comments: render_many(service.comments, CommentView, "comment.json"),
    }
  end

  def render("index_type.json", %{services: services, banners: banners}) do
    %{
      services: render_many(services, __MODULE__, "show.json"),
      banners: render_many(banners, BannerView, "show.json")
    }
  end

  def render("unauthenticated.json", _) do
    %{
      "error": "دسترسی ندارید"
    }
  end
end
