defmodule BackendWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :backend,
    pubsub_server: Backend.PubSub

  alias Backend.Accounts

  def fetch(_topic, presences) do
    IO.inspect presences
    users = presences |> Map.keys() |> Accounts.get_users_from_ids()

    for {key, %{metas: metas}} <- presences, into: %{} do
      {key, %{metas: metas, user: users[String.to_integer(key)]}}
    end
  end
end
