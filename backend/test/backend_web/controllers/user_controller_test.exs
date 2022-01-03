defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures
  import Backend.MediasFixtures

  alias Backend.Accounts.User
  alias Backend.Medias.Chat

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get user chats" do
    setup [:create_chat]

    test "get user chats for a user", %{
      conn: conn,
      chat: %Chat{id: id},
      user: %User{name: name} = user
    } do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> get(Routes.user_path(conn, :chat_list))

      assert %{
               "chats" => [
                 %{
                   "id" => ^id,
                   "users" => [
                     ^name
                   ],
                   "message" => ""
                 }
               ],
               "invited_chats" => []
             } = json_response(conn, 200)
    end
  end

  describe "create new chat" do
    setup [:create_user]

    test "create user chat with existing user", %{conn: conn, user: %User{name: name} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> post(Routes.user_path(conn, :create_chat), %{user_list: []})

      assert %{
               "id" => id,
               "users" => [
                 ^name
               ]
             } = json_response(conn, 201)

      assert is_number(id)
    end

    test "create user test with existing users", %{conn: conn, user: %User{name: name1} = user} do
      %User{email: email, name: name2} = user_fixture()

      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> post(Routes.user_path(conn, :create_chat), %{user_list: [email]})

      assert %{
               "id" => id,
               "users" => [
                 ^name1,
                 ^name2
               ]
             } = json_response(conn, 201)

      assert is_number(id)
    end

    test "create user chat with non-existing users", %{conn: conn, user: %User{name: name} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> post(Routes.user_path(conn, :create_chat), %{user_list: ["not_a_user@gmail.com"]})

      assert %{
               "id" => id,
               "users" => [
                 ^name
               ]
             } = json_response(conn, 201)

      assert is_number(id)
    end
  end

  describe "handle invitation" do
    setup [:create_invited_user]
    test "accept chat invitation", %{conn: conn, chat: %Chat{id: chat_id}, user: %User{} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> put(Routes.user_path(conn, :accept_chat, chat_id))

      assert "" = json_response(conn, 200)
      assert [{_chat, true}] = Backend.Accounts.get_chats(user.id)
    end

    test "accept non existing chat invitation", %{conn: conn, chat: %Chat{id: chat_id}, user: %User{} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> put(Routes.user_path(conn, :accept_chat, chat_id+1))

      assert "" = json_response(conn, 404)
      assert [{_chat, false}] = Backend.Accounts.get_chats(user.id)
    end

    test "delete chat invitation", %{conn: conn, chat: %Chat{id: chat_id}, user: %User{} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> delete(Routes.user_path(conn, :accept_chat, chat_id))

      assert "" = json_response(conn, 200)
      assert [] = Backend.Accounts.get_chats(user.id)
    end

    test "delete not existing chat invitation", %{conn: conn, chat: %Chat{id: chat_id}, user: %User{} = user} do
      conn =
        conn
        |> Backend.Guardian.Plug.put_current_resource(user)
        |> delete(Routes.user_path(conn, :accept_chat, chat_id+1))

      assert "" = json_response(conn, 404)
      assert [{_chat, false}] = Backend.Accounts.get_chats(user.id)
    end

  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_chat(_) do
    user = user_fixture()
    chat = chat_fixture(user.id)

    %{chat: chat, user: user}
  end

  defp create_invited_user(_) do
    user1 = user_fixture()
    user2 = user_fixture()
    chat = Backend.Accounts.add_user_chat(user1.id, [user2.email])

    %{chat: chat, user: user2}
  end
end
