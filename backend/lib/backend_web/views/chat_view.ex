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

  def render("page.json", %{messages: messages}) do
    render_many(messages, ChatView, "message.json", as: :message)
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      content: message.content,
      at: message.inserted_at,
      user: message.user,
      isMe: message.is_me
    }
  end

  def render("401.json", %{reason: reason}) do
    render_one(reason, ErrorView, "401.json")
  end

  def render("403.json", _params) do
    %{
      error: "Forbidden"
    }
  end
end
