defmodule BackendWeb.ChatView do
  use BackendWeb, :view

  alias BackendWeb.ChatView
  alias BackendWeb.ErrorView

  def render("show.json", %{chat: chat}) do
    %{
      id: chat.id,
      messages: render_many(chat.messages, ChatView, "message.json", as: :message),
      users: chat.users
    }
  end

  def render("message.json", %{message: message}) do
    %{
      content: message.content,
      at: message.inserted_at,
      user: message.user,
      isMe: message.is_me
    }
  end


  def render("401.json", %{reason: reason}) do
    render_one(reason, ErrorView, "401.json")
  end
end
