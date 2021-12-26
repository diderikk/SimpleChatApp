defmodule BackendWeb.ChatController do
  use BackendWeb, :controller

  alias Backend.Medias

  action_fallback BackendWeb.FallbackController

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    chat = Medias.get_chat!(id)
    render(conn, "show.json", chat: chat)
  end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
