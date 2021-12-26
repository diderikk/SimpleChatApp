defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  @spec update(any, map) :: {:error, Ecto.Changeset.t()} | Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  @spec delete(any, map) :: {:error, Ecto.Changeset.t()} | Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @spec chat_list(Plug.Conn.t(), any) :: Plug.Conn.t()
  def chat_list(conn, _params) do
    user = Backend.Guardian.Plug.current_resource(conn)
    chats = Accounts.get_user_chats(user.id)

    render(conn, "chat_list.json", chats: chats)
  end

  @spec invited_list(Plug.Conn.t(), any) :: Plug.Conn.t()
  def invited_list(conn, _params) do
    user = Backend.Guardian.Plug.current_resource(conn)
    invited_chats = Accounts.get_invited_chats(user.id)

    render(conn, "chat_list.json", chats: invited_chats)
  end

  @spec create_chat(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create_chat(conn, %{"user_list" => user_list}) do
    user = Backend.Guardian.Plug.current_resource(conn)
    new_chat = Accounts.add_user_chat(user.id, user_list)

    conn
    |> put_status(:created)
    |> render("chat.json", chat: new_chat)
  end
end
