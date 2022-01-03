defmodule BackendWeb.ChatController do
  use BackendWeb, :controller

  alias Backend.Medias
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => chat_id}) do
    user = %User{id: user_id} = Backend.Guardian.Plug.current_resource(conn)
    if Backend.Authorization.authorize_chat(user, String.to_integer(chat_id)) do
      chat = Medias.get_chat!(String.to_integer(chat_id), user_id)
      render(conn, "show.json", chat: chat)
    else
      conn
      |> put_status(:forbidden)
      |> render("403.json")
    end

  end
end
