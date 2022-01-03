defmodule Backend.Authorization do

  import Ecto.Query, warn: false


  alias Backend.Accounts.User
  alias Backend.Medias.Chat
  alias Backend.Repo

  @chat_query from c in Chat, select: c.id

  def authorize_chat(%User{} = user, chat_id) do
    user = user |> Repo.preload(chats: @chat_query)
    if chat_id in user.chats do
      true
    else
      false
    end
  end
end
