defmodule SsApiWeb.Router do
  use SsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug SsApiWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/gql", Absinthe.Plug.GraphiQL,
      schema: SsApi.Schema

    forward "/", Absinthe.Plug,
      schema: SsApi.Schema
  end
end
