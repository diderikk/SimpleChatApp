defmodule BackendWeb.ChatController do
  use BackendWeb, :controller

  alias Backend.Medias
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => chat_id}) do
    %User{id: user_id} = Backend.Guardian.Plug.current_resource(conn)
    chat = Medias.get_chat!(String.to_integer(chat_id), user_id)
    render(conn, "show.json", chat: chat)
  end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
