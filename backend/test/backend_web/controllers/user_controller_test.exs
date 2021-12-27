defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures
  import Backend.MediasFixtures

  alias Backend.Accounts.User
  alias Backend.Medias.Chat

  @update_attrs %{
    email: "some updated email",
    is_admin: true,
    name: "some updated name",
    token_version: 43
  }
  @invalid_attrs %{email: nil, is_admin: nil, name: nil, password_hash: nil, salt: nil, token_version: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "get user chats" do
    setup [:create_chat]
    test "get user chats for a user", %{conn: conn, chat: %Chat{id: id}, user: %User{name: name} = user} do
      conn = conn
      |> Backend.Guardian.Plug.put_current_resource(user)
      |> get(Routes.user_path(conn, :chat_list))

      assert %{
        "data" => [
          %{
            "id" => ^id,
            "users" => [
              ^name
            ]
          }
        ]
      } = json_response(conn, 200)
    end
  end

  describe "create new chat" do
    setup [:create_user]
    test "create user chat with existing user", %{conn: conn, user: %User{name: name} = user} do
      conn = conn
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
      conn = conn
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
      conn = conn
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

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_chat(_) do
    user = user_fixture()
    chat = chat_fixture(user.id)

    %{chat: chat, user: user}
  end
end
