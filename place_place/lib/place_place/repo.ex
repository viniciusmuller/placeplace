defmodule PlacePlace.Repo do
  use Ecto.Repo,
    otp_app: :place_place,
    adapter: Ecto.Adapters.Postgres
end
