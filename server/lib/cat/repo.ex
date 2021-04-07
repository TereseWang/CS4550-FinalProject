defmodule Cat.Repo do
  use Ecto.Repo,
    otp_app: :cat,
    adapter: Ecto.Adapters.Postgres
end
