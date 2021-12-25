defmodule Backend.Medias do
  @moduledoc """
  The Medias context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Medias.Chat

  @doc """
  Gets a single chat

  Raises `Ecto.NoResultsError` if the User does not exist.

    ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_chat!(number()) :: %Chat{}
  def get_chat!(chat_id), do: Repo.get!(Chat, chat_id)


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

end
