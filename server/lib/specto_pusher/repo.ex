defmodule SpectoPusher.Repo do
  use Ecto.Repo, otp_app: :specto_pusher, adapter: Sqlite.Ecto2
  use Scrivener, page_size: 10
end
