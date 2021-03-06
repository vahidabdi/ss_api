use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# SsApiWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.

# config :ss_api, SsApiWeb.Endpoint,
#   load_from_system_env: true,
#   http: [port: "4010"],
#   url: [host: "localhost", port: "4010"],
#   secret_key_base: "${SECRET_KEY_BASE}",
#   server: true

# Do not print debug messages in production
config :logger, level: :info

# # Configure your database
# config :ss_api, SsApi.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   hostname: "${DB_HOSTNAME}",
#   username: "${DB_USERNAME}",
#   password: "${DB_PASSWORD}",
#   database: "${DB_NAME}",
#   pool_size: 20

import_config "~/prod.exs"

config :ss_api,
  endpoint_url: "https://bot.setarehmorabae.ir"
  
