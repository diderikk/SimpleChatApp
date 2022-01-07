defmodule Backend.Medias.Chat do
  @moduledoc """
    Schema for Chat struct
  """
  use Ecto.Schema

  schema "chats" do
    many_to_many :users, Backend.Accounts.User, join_through: "users_chats"
    has_many :messages, Backend.Medias.Message, on_delete: :delete_all

    timestamps()
  end
end
