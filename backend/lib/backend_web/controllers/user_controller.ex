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
    chats = Accounts.get_chats(user.id)
    {part_of, invited_to} = Enum.split_with(chats, fn {_chat, has_accepted} -> has_accepted end)


    render(conn, "chat_list.json", [chats: part_of, invited_chats: invited_to])
  end

  @spec create_chat(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create_chat(conn, %{"user_list" => user_list}) do
    user = Backend.Guardian.Plug.current_resource(conn)
    new_chat = Accounts.add_user_chat(user.id, user_list)

    conn
    |> put_status(:created)
    |> render("chat.json", chat: new_chat)
  end

  @spec accept_chat(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def accept_chat(conn, %{"id" => chat_id}) do
    chat_id = String.to_integer(chat_id)
    user = Backend.Guardian.Plug.current_resource(conn)
    case Accounts.accept_chat(user.id, chat_id) do
      {1, _} -> conn |> put_status(:ok) |> render("none.json")

      {0, _} -> conn |> put_status(:not_found) |> render("none.json")

      _ -> conn |> put_status(500) |> render("none.json")

    end
  end

  @spec decline_chat(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def decline_chat(conn, %{"id" => chat_id}) do
    chat_id = String.to_integer(chat_id)
    user = Backend.Guardian.Plug.current_resource(conn)
    case Accounts.decline_chat(user.id, chat_id) do
      {1, _} -> conn |> put_status(:ok) |> render("none.json")

      {0, _} -> conn |> put_status(:not_found) |> render("none.json")

      _ -> conn |> put_status(500) |> render("none.json")

    end
  end
end
