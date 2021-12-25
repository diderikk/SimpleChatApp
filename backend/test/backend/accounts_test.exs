defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts
  alias Backend.Accounts.User

  import Backend.AccountsFixtures
  import Backend.MediaFixtures

  describe "users" do


    @invalid_attrs %{email: nil, is_admin: nil, name: nil, password: nil, password_hash: nil, salt: nil, token_version: nil}

    test "list_users/0 returns all users" do
      user = Map.put(user_fixture(), :password, nil)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = Map.put(user_fixture(), :password, nil)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some.email@gmail.com", name: "some name", password: "Password123"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some.email@gmail.com"
      assert user.is_admin == false
      assert user.name == "some name"
      assert is_binary(user.password_hash)
      assert is_binary(user.salt)
      assert user.token_version == 0
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with password without number and capital letter, data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{name: "name", email: "email@gmail.com", password: "password"})
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", is_admin: false, name: "some updated name", password_hash: "some updated password_hash", salt: "some updated salt", token_version: 43}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.is_admin == false
      assert user.name == "some updated name"
      assert user.password_hash != "some updated password_hash"
      assert user.salt != "some updated salt"
      assert user.token_version == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Map.put(user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end


    test "authenticate/2 returns a access and refresh token" do
      user = user_fixture()
      assert {:ok, _access, _refresh } = Accounts.authenticate(user.email, user.password)
    end

    test "authenticate/2 does not authenticate when wrong password" do
      user = user_fixture()
      assert {:error, _reason } = Accounts.authenticate(user.email, "Wrong password")
    end

    test "authenticate/2 does not authenticate when it doesnt find email" do
      user = user_fixture()
      assert {:error, _reason } = Accounts.authenticate("user.email@gmail.com", user.password)
    end

    test "get_user_chats/1 returns all users in chat" do
      user = user_fixture()
      chat = chat_fixture(user.id)

      assert Accounts.get_user_chats(user.id) == [chat]

    end

    test "get_user_chats/1 returns empty when user does not exist" do
      assert Accounts.get_user_chats(0) == []
    end

    test "add_user_chat/2 returns a chat with the creator as a member" do
      user = user_fixture()
      chat = Accounts.add_user_chat(user.id, [])

      assert Accounts.get_user_chats(user.id) == [chat]
    end
  end
end
