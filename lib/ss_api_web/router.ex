defmodule SsApiWeb.Router do
  use SsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :gql do
    plug SsApiWeb.Context
  end

  scope "/api", SsApiWeb do
    pipe_through :api

    get "/get_meta", MetaController, :index

    post "/users", UserController, :create
    post "/users/login", UserController, :login
    get "/users/current_user", UserController, :current_user
    post "/users/current_user", UserController, :current_user
    get "/users/current_user/favourites", UserController, :current_user_favourites
    post "/users/:service_id/favourite", UserController, :favourite
    delete "/users/:service_id/remove", UserController, :remove_service

    resources "/services", ServiceController, only: [:index, :show]
    get "/services/type/:type_id", ServiceController, :get_type
    post "/services/:service_id/likes", ServiceController, :likes
    post "/services/:service_id/comment", ServiceController, :comment
    post "/search", ServiceController, :search

    # resources "/comments", CommentController, only: [:create, :index]
  end

  scope "/graphql" do
    pipe_through [:api, :gql]

    forward "/gql", Absinthe.Plug.GraphiQL,
      schema: SsApi.Schema

    forward "/", Absinthe.Plug,
      schema: SsApi.Schema
  end
end
