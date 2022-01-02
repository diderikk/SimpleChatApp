defmodule Backend.Medias do
  @moduledoc """
  The Medias context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Medias.Chat
  alias Backend.Accounts.User
  alias Backend.Medias.Message

  @doc """
  Gets a single chat

  Raises `Ecto.NoResultsError` if the User does not exist.

    ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_chat!(number(), number()) :: %Chat{}
  def get_chat!(chat_id, user_id) do
    message_query = from m in Message, order_by: [m.inserted_at, m.id], select: [:content, :inserted_at, :user_id]
    user_query = from u in User, select: u.name
    member_query = from u in User, join: uc in "users_chats",
    on: u.id == uc.user_id and uc.has_accepted and uc.chat_id == ^chat_id, select: u.name
    chat = Repo.get!(Chat, chat_id)
    |> Repo.preload([messages: {message_query, [user: user_query]}, users: member_query])

    messages = Enum.map(chat.messages, fn message -> Map.put_new(message, :is_me, user_id == message.user_id) end)
    Map.put(chat, :messages, messages)
  end


  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}
  """
  @spec delete_chat(%Chat{}) :: {:ok, %Chat{}} | {:error, %Ecto.Changeset{}}
  def delete_chat(%Chat{} = chat) do
    Repo.delete_all(from c in "users_chats", where: c.chat_id == ^chat.id)
    Repo.delete(chat)
  end

  @doc """
  Persists a message.

  ## Examples

      iex> persist_message(user, chat_id, %{content, at})
      {:ok, %Message{}}

      iex> persist_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec persist_message(number(), number(), map()) :: {:ok, %Message{}} | {:error, %Ecto.Changeset{}}
  def persist_message(user_id, chat_id, attrs) do
    %Message{user_id: user_id, chat_id: chat_id}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

end
