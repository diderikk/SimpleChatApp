defmodule Backend.ChatChannel do
  use Phoenix.Channel

  alias Backend.Medias.Message
  alias Backend.Medias

  def join("chat:" <> chat_id, _params, socket) do
    send(self(), :joined)
    {:ok, assign(socket, :chat_id, String.to_integer(chat_id))}
  end

  def handle_info(:joined, socket) do
    push(socket, "joined", %{user: socket.assigns.user_name})
    {:noreply, socket}
  end

  def handle_in("message", %{"content" => content} = params, socket) do
    with {:ok, %Message{inserted_at: at}} <-
           Medias.persist_message(socket.assigns.user_id, socket.assigns.chat_id, params) do
      broadcast!(socket, "message", %{
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
