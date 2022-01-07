defmodule BackendWeb.ChatChannel do
  @moduledoc """
    Implementation for a chat channel using Phoenix Channel
  """
  use Phoenix.Channel

  alias Backend.Medias.Message
  alias Backend.Medias
  alias BackendWeb.Presence

  def join("chat:" <> chat_id, _params, socket) do
    user = Backend.Accounts.get_user!(socket.assigns.user_id)

    case Backend.Authorization.authorize_chat(user, String.to_integer(chat_id)) do
      true ->
        send(self(), :after_join)
        {:ok, assign(socket, :chat_id, String.to_integer(chat_id))}

      _ ->
        {:error, %{reason: "Forbidden"}}
    end
  end

  @spec handle_info(:after_join, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second))
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in("message", %{"content" => content} = params, socket) do
    case Medias.persist_message(socket.assigns.user_id, socket.assigns.chat_id, params) do
      {:ok, %Message{inserted_at: at, id: id}} ->
        broadcast!(socket, "message", %{
          id: id,
          content: content,
          user: socket.assigns.user_name,
          at: at,
          user_id: socket.assigns.user_id
        })

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
