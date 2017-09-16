defmodule SsApi.Schema.ArcResolver do
  @moduledoc """
  Provides helper function to get
  """

  @endpoint_url Application.get_env(:ss_api, :endpoint_url)

  defmacro __using__([uploader: uploader]) do
    quote do
      import unquote(__MODULE__), only: [
        arc_file: 2,
        arc_file: 3,
      ]
      @__arc_upload unquote(uploader)
    end
  end

  defmacro arc_file(field, version) do
    quote do
      unquote(__MODULE__).arc_file(@__arc_upload, unquote(field), unquote(version))
    end
  end

  def arc_file(uploader, field, version) do
    fn parent, _, _ ->
      res = apply(uploader, :url, [{parent.picture, parent}, version])
      {:ok, @endpoint_url <> res}
    end
  end
end
