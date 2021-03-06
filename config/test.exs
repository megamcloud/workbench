use Mix.Config

# Configure your database
config :workbench, Workbench.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres",
  password: "postgres",
  database: "workbench_test",
  hostname: System.get_env("DB_HOST", "localhost"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :workbench, WorkbenchWeb.Endpoint,
  http: [port: 4002],
  server: false

config :tai, advisor_groups: %{}

config :tai, venues: %{}

config :workbench,
  balance_snapshot: %{
    enabled: true,
    btc_usd_venue: :mock_venue_a,
    btc_usd_symbol: :btc_usdt,
    usd_quote_venue: :mock_venue_a,
    usd_quote_asset: :usdt
  }
