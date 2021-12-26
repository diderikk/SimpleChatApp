defmodule Backend.MediasTest do
  use Backend.DataCase

  alias Backend.Medias
  alias Backend.Medias.Chat
  alias Backend.Medias.Message

  import Backend.AccountsFixtures
  import Backend.MediasFixtures

  describe "chats" do

    test "get_chat!/1 returns the chat given with id" do
      chat = chat_fixture(user_fixture().id)
      chat =
      chat
      |> Map.put(:messages, [])
      |> Map.put(:users, [user_fixture().name])

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

    test "send_message/3 sends a message in a chat from a user" do
      user = user_fixture()
      chat = chat_fixture(user.id)
      assert {:ok, %Message{} = message} = Medias.send_message(user, chat.id, %{content: "Test"})
      assert is_map(message)
      assert message.content == "Test"
    end
  end

end
