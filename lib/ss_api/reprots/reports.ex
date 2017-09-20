defmodule SsApi.Reports do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias SsApi.Repo
  alias SsApi.Reports
  alias SsApi.Vas.Type

  schema "reports" do
    field :views, :integer
    field :runs, :integer
    field :report_date, :date
    belongs_to :type, Type
  end

  def list_reports(type_id) do
    query =
      Reports
      |> preload([:type])
      |> where([r], r.type_id == ^type_id)
      |> where([r], r.report_date > date_add(^Date.utc_today, -30, "day"))
    IO.inspect query
    query
    |> Repo.all()
  end
end
