defmodule SsApi.BannerImage do
  use Arc.Definition
  use Arc.Ecto.Definition

  # @versions [:original]

  # To add a thumbnail version:
  @versions [:original, :banner1x, :banner2x, :banner3x]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:banner1x, _) do
    {:convert, "-strip -quality 90% -thumbnail 382x212^ -gravity center -extent 382x212 -format jpg", :jpg}
  end
  def transform(:banner2x, _) do
    {:convert, "-strip -quality 90% -thumbnail 764x424^ -gravity center -extent 764x424 -format jpg", :jpg}
  end
  def transform(:banner3x, _) do
    {:convert, "-strip -quality 90% -thumbnail 1528x848^ -gravity center -extent 1528x848 -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, {_file, _scope}) do
    "#{version}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/banner/#{scope.filename}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
