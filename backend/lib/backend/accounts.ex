defmodule Backend.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.User
  alias Backend.Guardian
  alias Backend.Medias.Chat
  alias Backend.Medias.Message

  @user_query from(u in User, select: u.name)
  @message_query from(m in Message, order_by: [desc: m.inserted_at], select: [:content])

  @doc """
  Gets users from an array of ids

  ## Examples

    iex> get_users_from_ids([1,2,3])

    [
      %User{},
      ...
    ]
  """
  @spec get_users_from_ids(list()) :: list(User.t())
  def get_users_from_ids(ids) do
    Repo.all(
      from(u in User,
        where: u.id in ^ids,
        select: {u.id, u.name}
      )
    )
    |> Enum.into(%{})
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(number()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(User.t(), map()) :: Ecto.Changeset.t()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Authentication for user by finding the user from email and verifying the given password with the users hash

  ## Examples
    iex> authenticate("username", "password")
    {access_token, refresh_token}
  """
  @spec authenticate(binary, binary) :: {:error, binary()} | {:ok, binary(), binary()}
  def authenticate(email, password) when is_binary(email) and is_binary(password) do
    with %User{} = user <- Repo.get_by(User, email: email) do
      if User.valid_password?(password, user) do
        {:ok, user} = update_user(user, %{token_version: user.token_version + 1})
        {access_token, refresh_token} = Guardian.create_access_and_refresh_tokens(user)
        {:ok, access_token, refresh_token}
      else
        {:error, "Could not log in"}
      end
    else
      _ -> {:error, "No user with that email"}
    end
  end

  def authenticate(_, _), do: {:error, "Could not log in"}

  @doc """
  Returns all chats that a given user is connected to

  ## Example
    iex> get_chats(user_id)
    [
      %Backend.Medias.Chat{
        id,
        messages: [last message],
        users
      }
    ]
  """
  @spec get_chats(number()) :: list()
  def get_chats(user_id) do
    chats =
      Repo.all(
        from(c in Chat,
          join: u in "users_chats",
          on: c.id == u.chat_id and u.user_id == ^user_id,
          select: {c, u.has_accepted},
          preload: [users: ^@user_query, messages: ^@message_query],
          order_by: [desc: c.inserted_at]
        )
      )

    Enum.map(
      chats,
      fn {chat, has_accepted} ->
        {Map.put(
           chat,
           :messages,
           if(List.first(chat.messages) != nil, do: [List.first(chat.messages)], else: [])
         ), has_accepted}
      end
    )
  end

  @doc """
  Creates a chat and adds the creator of the chat and inviting the users given by ids in the list

  ## Example
    iex> add_user_chat(1, [2,3,4])

    %Backend.Medias.Chat{}

    iex> add_user_chat(1, [])

    {:error, reason}

  """
  @spec add_user_chat(number(), list()) :: Chat.t()
  def add_user_chat(user_id, user_email_list) when is_list(user_email_list) do
    user_id_list = Repo.all(from(u in User, where: u.email in ^user_email_list, select: u.id))

    if Enum.empty?(user_id_list) do
      {:error, "Empty invite list"}
    else
      chat = Repo.insert!(%Chat{})
      creator = [%{user_id: user_id, chat_id: chat.id, has_accepted: true}]
      invited_users = Enum.map(user_id_list, fn id -> %{user_id: id, chat_id: chat.id} end)
      |> Enum.reject(fn user_chat -> user_chat.user_id == user_id end)
      Repo.insert_all("users_chats", creator ++ invited_users)

      chat
      |> Repo.preload(users: @user_query)
    end
  end

  @doc """
    Accepts a chat a user is invited to

    ## Example
      iex> accept_chat(1,1)

      {1, nil}

  """
  @spec accept_chat(number(), number()) :: {number(), nil | list()}
  def accept_chat(user_id, chat_id) do
    from(uc in "users_chats", where: uc.chat_id == ^chat_id and uc.user_id == ^user_id)
    |> Repo.update_all(set: [has_accepted: true])
  end

  @doc """
    Declines a chat a user is invited to

    ## Example
      iex> decline(1,1)

      {1, nil}

  """
  @spec decline_chat(number(), number()) :: {number(), nil | list()}
  def decline_chat(user_id, chat_id) do
    members = from(uc in "users_chats", where: uc.chat_id == ^chat_id, select: [:user_id])
    |> Repo.all()

    if length(members) == 2 do
      from(uc in "users_chats", where: uc.chat_id == ^chat_id)
      |> Repo.delete_all()
      from(m in Message, where: m.chat_id == ^chat_id)
      |> Repo.delete_all()
      from(c in Chat, where: c.id == ^chat_id)
      |> Repo.delete_all()
      {1, nil}
    else
      from(uc in "users_chats", where: uc.chat_id == ^chat_id and uc.user_id == ^user_id)
      |> Repo.delete_all()
    end
  end
end
