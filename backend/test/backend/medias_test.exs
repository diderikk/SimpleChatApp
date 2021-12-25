defmodule Backend.MediasTest do
  use Backend.DataCase

  alias Backend.Medias
  alias Backend.Medias.Chat

  import Backend.AccountsFixtures
  import Backend.MediaFixtures

  describe "chats" do

    test "get_chat!/1 returns the chat given with id" do
      chat = chat_fixture(user_fixture().id)

      assert Medias.get_chat!(chat.id) == chat
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture(user_fixture().id)
      assert {:ok, %Chat{}} = Medias.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Medias.get_chat!(chat.id) end
    end

    test "delete_chat/1 deletes chat that does not exist" do
      assert_raise FunctionClauseError, fn -> Medias.delete_chat(nil) end
    end
  end

end
