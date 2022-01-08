defmodule Backend.MediasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Media` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(user_id, user_email) do
    Backend.Accounts.add_user_chat(user_id, [user_email])
  end
end
