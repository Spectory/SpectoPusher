use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coyote, CoyoteWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Dummy access key, for admin login and API requests.
System.put_env("ACCESS_KEY", "testfreepass")
# Dummy crypto salt, used to sign/verify tokens.
System.put_env("CRYPTO_SALT", "crypto_salt")
