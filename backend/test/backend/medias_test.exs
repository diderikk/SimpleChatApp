defmodule Backend.MediasTest do
  use Backend.DataCase

  alias Backend.Medias
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

    test "persist_message/3 persists a message in a chat from a user" do
      user = user_fixture()
      chat = chat_fixture(user.id)
      assert {:ok, %Message{} = message} = Medias.persist_message(user.id, chat.id, %{content: "Test"})
      assert is_map(message)
      assert message.content == "Test"
    end
  end

end
