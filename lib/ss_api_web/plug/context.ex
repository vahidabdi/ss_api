defmodule SsApiWeb.Context do
  @moduledoc """
  Plug which sets current_user
  """

  @behaviour Plug

  import Plug.Conn
  alias Guardian.Plug, as: GPlug

  def init(opts), do: opts

  def call(conn, _) do
    case GPlug.current_resource(conn) do
      nil ->
        conn
      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end
