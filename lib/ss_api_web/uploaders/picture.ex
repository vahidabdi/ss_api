defmodule SsApi.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  # @versions [:original]

  # To add a thumbnail version:
  @versions [:original, :thumb, :thumb1x, :thumb2x]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -quality 90% -thumbnail 94x76^ -gravity center -extent 94x76 -format jpg", :jpg}
  end
  def transform(:thumb1x, _) do
    {:convert, "-strip -quality 90% -thumbnail 384x250^ -gravity center -extent 384x250 -format jpg", :jpg}
  end
  def transform(:thumb2x, _) do
    {:convert, "-strip -quality 90% -thumbnail 760x610^ -gravity center -extent 760x610 -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, {_file, _scope}) do
    "#{version}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/pictures/#{scope.filename}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, scope) do
    "/images/avatars/default_#{version}.jpg"
  end
end
