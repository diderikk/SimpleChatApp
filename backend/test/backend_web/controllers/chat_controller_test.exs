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

    test "GET /api/chats/:id returns chat when chat exists", %{
      conn: conn,
      chat: %Chat{id: id},
      user: %User{name: name} = user
    } do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> get(Routes.chat_path(conn, :show, id))
        |> doc(description: "Gets chat when it exists")

      assert %{
               "id" => ^id,
               "users" => [^name],
               "messages" => []
             } = json_response(conn, 200)
    end

    test "GET /api/chats/:id returns chat when chat exists with message", %{
      conn: conn,
      chat: %Chat{id: id},
      user: %User{name: name} = user
    } do
      Medias.persist_message(user.id, id, %{content: "some message"})

      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> get(Routes.chat_path(conn, :show, id))
        |> doc(description: "Gets a chat with message")

      assert %{
               "id" => ^id,
               "users" => [^name],
               "messages" => [%{"content" => "some message", "user" => ^name}]
             } = json_response(conn, 200)
    end

    test "authorization", %{conn: conn, chat: %Chat{id: id}, user: %User{} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> get(Routes.chat_path(conn, :show, id + 1))
        |> doc(description: "Gets a non-authorized chat")

      assert %{
               "error" => "Forbidden"
             } = json_response(conn, 403)
    end
  end

  describe "get next page" do
    setup [:create_chat]

    test "GET /chats/:id/:page with not enough messages", %{
      conn: conn,
      chat: %Chat{id: id},
      user: %User{} = user
    } do
      Medias.persist_message(user.id, id, %{content: "some message"})

      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> get(Routes.chat_path(conn, :page, id, 1))
        |> doc(description: "Gets next page from chat")

      assert [] = json_response(conn, 200)
    end
  end

  defp create_chat(_) do
    user = user_fixture()
    chat = chat_fixture(user.id, user_fixture().email)

    %{chat: chat, user: user}
  end
end
