defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts

  action_fallback BackendWeb.FallbackController

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
