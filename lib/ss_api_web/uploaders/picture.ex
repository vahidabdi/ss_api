defmodule SsApi.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  # @versions [:original]

  # To add a thumbnail version:
  @versions [:original, :thumb1x, :thumb2x, :thumb3x, :banner1x, :banner2x, :banner3x]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb1x, _) do
    {:convert, "-strip -quality 90% -thumbnail 117x95^ -gravity center -extent 117x95 -format jpg", :jpg}
  end
  def transform(:thumb2x, _) do
    {:convert, "-strip -quality 90% -thumbnail 234x190^ -gravity center -extent 234x190 -format jpg", :jpg}
  end
  def transform(:thumb3x, _) do
    {:convert, "-strip -quality 90% -thumbnail 468x380^ -gravity center -extent 468x380 -format jpg", :jpg}
  end
  def transform(:banner1x, _) do
    {:convert, "-strip -quality 90% -thumbnail 382x252^ -gravity center -extent 382x252 -format jpg", :jpg}
  end
  def transform(:banner2x, _) do
    {:convert, "-strip -quality 90% -thumbnail 764x504^ -gravity center -extent 764x504 -format jpg", :jpg}
  end
  def transform(:banner3x, _) do
    {:convert, "-strip -quality 90% -thumbnail 1528x1008^ -gravity center -extent 1528x1008 -format jpg", :jpg}
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
  def default_url(version, _scope) do
    "/images/avatars/default_#{version}.jpg"
  end
end
