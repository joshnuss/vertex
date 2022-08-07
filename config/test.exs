import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :analytics, AnalyticsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "tU8VChA0PQrmZ4JziE16ADMY5fLjvG2lVcETNrdS+mZfGV1enLSnqpMoO7ysczsf",
  server: false

# In test we don't send emails.
config :analytics, Analytics.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :analytics, backend: Analytics.Backend.Testing

config :analytics, :clickhouse,
  database: "analytics",
  url: "http://localhost:6001"
