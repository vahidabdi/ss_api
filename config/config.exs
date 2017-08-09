# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ss_api,
  ecto_repos: [SsApi.Repo]

# Configures the endpoint
config :ss_api, SsApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0Pew/IoSPxpQr6HPyuZxqU93CG8whvm47395VMPKkuq79M5FIbE12sfXD762mGK3",
  render_errors: [view: SsApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SsApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "SsApi",
  ttl: { 1, :year },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "NAwyovcc/uSe95avlTCS9qMzeIK/8t+MEb/IIdBEJBVAjLfbYqVSWqoXyvtsQ0X4",
  serializer: SsApi.GuardianSerializer
\
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
