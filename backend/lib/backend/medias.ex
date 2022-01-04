defmodule Backend.Medias do
  @moduledoc """
  The Medias context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Medias.Chat
  alias Backend.Accounts.User
  alias Backend.Medias.Message

  @user_query from u in User, select: u.name

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
    message_query =
      from m in Message,
        order_by: [desc: m.inserted_at],
        select: [:content, :inserted_at, :user_id, :id],
        limit: 15

    member_query =
      from u in User,
        join: uc in "users_chats",
        on: u.id == uc.user_id and uc.has_accepted and uc.chat_id == ^chat_id,
        select: u.name

    chat =
      Repo.get!(Chat, chat_id)
      |> Repo.preload(messages: {message_query, [user: @user_query]}, users: member_query)

    messages =
      Enum.reverse(chat.messages)
      |> Enum.map(fn message -> Map.put_new(message, :is_me, user_id == message.user_id)
      end)

    Map.put(chat, :messages, messages)
  end

  @doc """
  Returns a list of messages from a chat

  ## Examples

    iex> get_page_messages(1, 1, 1)

    [
      %Message{}
      ...
    ]
  """

  @spec get_page_messages(number(), number(), number()) :: list
  def get_page_messages(chat_id, user_id, page) do
    Repo.all(
      from m in Message,
        where: m.chat_id == ^chat_id,
        order_by: [desc: m.id],
        select: [:content, :inserted_at, :user_id, :id],
        offset: 15 * ^page,
        limit: 15,
        preload: [user: ^@user_query]
    )
    |> Enum.reverse()
    |> Enum.map(fn message -> Map.put_new(message, :is_me, user_id == message.user_id) end)
  end

  @doc """
  Persists a message.

  ## Examples

      iex> persist_message(user, chat_id, %{content, at})
      {:ok, %Message{}}

      iex> persist_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec persist_message(number(), number(), map()) ::
          {:ok, %Message{}} | {:error, %Ecto.Changeset{}}
  def persist_message(user_id, chat_id, attrs) do
    %Message{user_id: user_id, chat_id: chat_id}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
