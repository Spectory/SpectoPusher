defmodule Coyote.Repo do
  use Ecto.Repo, otp_app: :coyote, adapter: Sqlite.Ecto2
  use Scrivener, page_size: 10
end
