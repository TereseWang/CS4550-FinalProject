# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cat,
  ecto_repos: [Cat.Repo]

config :cat,
  mix_env: "#{Mix.env()}"
  
# Configures the endpoint
config :cat, CatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5Gr/bDqOWg017CfbOCrrLtoH+po5m6sI/4uagtJ3sSQarBUgNU5oKC85Fiu4MJ6X",
  render_errors: [view: CatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Cat.PubSub,
  live_view: [signing_salt: "ZDMT3psa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
