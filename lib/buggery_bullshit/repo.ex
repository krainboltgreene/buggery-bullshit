defmodule BuggeryBullshit.Repo do
  use Ecto.Repo,
    otp_app: :buggery_bullshit,
    adapter: Ecto.Adapters.Postgres
end
