defmodule Backend.ChatChannel do
  use Phoenix.Channel

  alias Backend.Medias.Message
  alias Backend.Medias

  def join("chat:" <> chat_id, _params, socket) do
    user = Backend.Accounts.get_user!(socket.assigns.user_id)
    case Backend.Authorization.authorize_chat(user, String.to_integer(chat_id)) do
      true ->
        send(self(), :joined)
        {:ok, assign(socket, :chat_id, String.to_integer(chat_id))}
      _ ->
        {:error, %{reason: "Forbidden"}}
    end
  end

  @spec handle_info(:joined, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:joined, socket) do
    push(socket, "joined", %{user: socket.assigns.user_name})
    {:noreply, socket}
  end

  def handle_in("message", %{"content" => content} = params, socket) do
    with {:ok, %Message{inserted_at: at, id: id}} <-
           Medias.persist_message(socket.assigns.user_id, socket.assigns.chat_id, params) do
      broadcast!(socket, "message", %{
        id: id,
        content: content,
        user: socket.assigns.user_name,
        at: at,
        user_id: socket.assigns.user_id
      })

      {:reply, :ok, socket}
    else
      {:error, changeset} -> {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
