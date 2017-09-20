defmodule SsApiWeb.ReportResolver do

  alias SsApi.Reports

  def list_reprots(%{type_id: type_id}, %{context: %{current_user: %{id: id}}}) do
    {:ok, Reports.list_reports(type_id)}
  end
  def list(_args, _info) do
    {:error, "unauthorized"}
  end

end
