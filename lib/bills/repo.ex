defmodule Bills.Repo do
  use Ecto.Repo,
    otp_app: :bills,
    adapter: Ecto.Adapters.Postgres
end
