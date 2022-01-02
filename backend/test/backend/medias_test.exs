defmodule Backend.MediasTest do
  use Backend.DataCase

  alias Backend.Medias
  alias Backend.Medias.Chat
  alias Backend.Medias.Message

  import Backend.AccountsFixtures
  import Backend.MediasFixtures

  describe "chats" do

    test "get_chat!/2 returns the chat given with id" do
      id = user_fixture().id
      chat = chat_fixture(id)
      chat =
      chat
      |> Map.put(:messages, [])
      |> Map.put(:users, [user_fixture().name])

      assert Medias.get_chat!(chat.id, id) == chat
    end

    test "delete_chat/1 deletes the chat" do
      user_id = user_fixture().id
      chat = chat_fixture(user_id)
      assert {:ok, %Chat{}} = Medias.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Medias.get_chat!(chat.id, user_id) end
    end

    test "delete_chat/1 deletes chat that does not exist" do
      assert_raise FunctionClauseError, fn -> Medias.delete_chat(nil) end
    end

    test "persist_message/3 persists a message in a chat from a user" do
      user = user_fixture()
      chat = chat_fixture(user.id)
      assert {:ok, %Message{} = message} = Medias.persist_message(user.id, chat.id, %{content: "Test"})
      assert is_map(message)
      assert message.content == "Test"
    end
  end

end
