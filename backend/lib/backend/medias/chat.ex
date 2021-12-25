defmodule Backend.Medias.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    many_to_many :users, Backend.Accounts.User, join_through: "users_chats"

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> validate_required([])
  end
end
