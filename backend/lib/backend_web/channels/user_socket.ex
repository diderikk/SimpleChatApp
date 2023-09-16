defmodule BackendWeb.UserSocket do
  use Phoenix.Socket

  alias Backend.Accounts

  channel "chat:*", BackendWeb.ChatChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    IO.inspect(token)
    IO.inspect(Base.decode64!(token))
    case Backend.Guardian.decode_and_verify(Base.decode64!(token)) do
      {:ok, %{"sub" => user_id}} ->
        socket = assign(socket, :user_name, Accounts.get_user!(String.to_integer(user_id)).name)
        {:ok, assign(socket, :user_id, String.to_integer(user_id))}

      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket, _connect_info), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
