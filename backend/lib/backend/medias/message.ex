defmodule Backend.Medias.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :chat, Backend.Medias.Chat
    belongs_to :user, Backend.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> assoc_constraint(:chat)
    |> assoc_constraint(:user)
  end
end
