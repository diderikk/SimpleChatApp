defmodule BackendWeb.ChatControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures
  import Backend.MediasFixtures

  alias Backend.Medias.Chat
  alias Backend.Accounts.User
  alias Backend.Medias

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get chat" do
    setup [:create_chat]
    test "returns chat when chat exists", %{conn: conn, chat: %Chat{id: id}, user: %User{name: name}} do
      conn = get(conn, Routes.chat_path(conn, :show, id))
      assert %{
        "id" => ^id,
        "users" => [^name],
        "messages" => []
      } = json_response(conn, 200)
    end

    test "returns 404 not found when chat does not exist", %{conn: conn, chat: %Chat{id: id}, user: _user} do
      assert_error_sent 404, fn -> get(conn, Routes.chat_path(conn, :show, id+1)) end
    end

    test "returns chat when chat exists with message", %{conn: conn, chat: %Chat{id: id}, user: %User{name: name} = user} do
      Medias.send_message(user, id, %{content: "some message"})
      conn = get(conn, Routes.chat_path(conn, :show, id))
      assert %{
        "id" => ^id,
        "users" => [^name],
        "messages" => [%{"content" => "some message", "user" => ^name}]
      } = json_response(conn, 200)

    end
  end


  defp create_chat(_) do
    user = user_fixture()
    chat = chat_fixture(user.id)

    %{chat: chat, user: user}
  end
end
