defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("chat_list.json", %{chats: chats}) do
    %{
      data: render_many(chats, UserView, "chat.json", as: :chat)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
    }
  end

  def render("chat.json", %{chat: chat}) do
    %{
      id: chat.id,
      users: chat.users
    }
  end
end
