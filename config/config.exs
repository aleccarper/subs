# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :subs,
  ecto_repos: [Subs.Repo]

# Configures the endpoint
config :subs, SubsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5jEtqcX2Onhh3Qxo6gCnRymB/Ur1IhP+KlAVUwuS6TPySmflBXWQGHCmZGIwnnAq",
  render_errors: [view: SubsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Subs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
