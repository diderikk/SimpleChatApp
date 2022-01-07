defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("chat_list.json", %{chats: chats, invited_chats: invited_chats}) do
    %{
      chats: render_many(chats, UserView, "chat.json", as: :chat),
      invited_chats: render_many(invited_chats, UserView, "chat.json", as: :chat)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end

  def render("chat.json", %{chat: {chat, _}}) do
    message = List.first(chat.messages)

    %{
      id: chat.id,
      users: chat.users,
      message:
        if message do
          message.content
        else
          ""
        end
    }
  end

  def render("chat.json", %{chat: chat}) do
    %{
      id: chat.id,
      users: chat.users,
      message: ""
    }
  end

  def render("none.json", _params) do
    ""
  end
end
