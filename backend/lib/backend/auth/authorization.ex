defmodule Backend.Authorization do
  @moduledoc """
    Module for authorization
  """

  import Ecto.Query, warn: false

  alias Backend.Accounts.User
  alias Backend.Medias.Chat
  alias Backend.Repo

  @chat_query from c in Chat, select: c.id

  @spec authorize_chat(Backend.Accounts.User.t(), number()) :: boolean
  def authorize_chat(%User{} = user, chat_id) do
    user = user |> Repo.preload(chats: @chat_query)

    if chat_id in user.chats do
      true
    else
      false
    end
  end
end
