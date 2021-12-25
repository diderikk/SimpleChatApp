defmodule Backend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.User
  alias Backend.Guardian
  alias Backend.Medias.Chat

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users() :: list()
  def list_users do
    Repo.all(User)
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
  @spec get_user!(number()) :: %User{}
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
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
  @spec update_user(%User{}, map()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(%User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete_all(from c in "users_chats", where: c.user_id == ^user.id)
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(%User{}, map()) :: %Ecto.Changeset{data: %User{}}
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
        { access_token, refresh_token } = Guardian.create_access_and_refresh_tokens(user)
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
  Returns all chats that a given user exists in

  ## Example
    iex> get_user_chats(user_id)
    [
      %Backend.Medias.Chat{}
    ]
  """
  @spec get_user_chats(number()) :: list()
  def get_user_chats(user_id) do
    Repo.all(
      from c in Chat,
      join: u in "users_chats",
      on: c.id == u.chat_id
      and u.has_accepted and u.user_id == ^user_id
    )
  end

  @doc """
  Returns all chats that a given user is invited to

  ## Example
    iex> get_invited_chats(user_id)
    [
      %Backend.Medias.Chat{}
    ]
  """
  @spec get_invited_chats(number()) :: list()
  def get_invited_chats(user_id) do
    Repo.all(
      from c in Chat,
      join: u in "users_chats",
      on: c.id == u.chat_id
      and not u.has_accepted and u.user_id == ^user_id
    )
  end

  @doc """
  Creates a chat and adds the creator of the chat and inviting the users given by ids in the list

  ## Example
    iex> add_user_chat(1, [2,3,4])

    { :ok, %Backend.Medias.Chat{} }

  """
  @spec add_user_chat(number(), list()) :: %Chat{}
  def add_user_chat(user_id, user_id_list) when is_list(user_id_list) do
    chat = Repo.insert!(%Chat{})
    creator = [%{user_id: user_id, chat_id: chat.id, has_accepted: true}]
    invited_users = Enum.map(user_id_list, fn id -> %{user_id: id, chat_id: chat.id} end)
    Repo.insert_all("users_chats", creator ++ invited_users)

    chat
  end
end
