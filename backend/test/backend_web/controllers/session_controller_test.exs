defmodule BackendWeb.SessionControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures

  alias Backend.Accounts.User

  @create_attrs %{
    email: "test@test.com",
    name: "some name",
    password: "Password123",
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign in user" do
    setup [:create_user]
    test "renders token when signed in user", %{conn: conn, user: %User{} = user} do
      conn = post(conn, Routes.session_path(conn, :signin), %{email: user.email, password: "Password123"})
      assert is_binary(json_response(conn, 200)["token"])
    end

    test "renders errors when sign in password is wrong", %{conn: conn, user: %User{} = user} do
      conn = post(conn, Routes.session_path(conn, :signin), %{email: user.email, password: "Password"})
      assert %{
        "detail" => detail
      } = json_response(conn, 401)["errors"]
      assert is_binary(detail)
    end

    test "renders errors when sign in email does not exist", %{conn: conn, user: %User{} = _user} do
      conn = post(conn, Routes.session_path(conn, :signin), %{email: "wrong email", password: "Password"})
      assert %{
        "detail" => "Unauthorized"
      } = json_response(conn, 401)["errors"]
    end
  end

  describe "sign up user" do
    setup [:create_user]
    test "renders token and user when signed up", %{conn: conn, user: %User{} = _user} do
      conn = post(conn, Routes.session_path(conn, :signup), user: @create_attrs)

      response = json_response(conn, 201)
      assert is_binary(response["token"])
      user = response["user"]

      assert user["name"] == @create_attrs.name
      assert user["email"] == @create_attrs.email
    end

    test "renders errors when invalid attrs", %{conn: conn, user: %User{} = _user} do
      conn = post(conn, Routes.session_path(conn, :signup), user: @invalid_attrs)
      assert %{
        "errors" => %{
          "email" => email,
          "name" => name,
          "password" => password
        }
      } = json_response(conn, 422)

      assert is_list(email)
      assert is_list(name)
      assert is_list(password)
    end

    test "renders errors when taken email", %{conn: conn, user: %User{} = user} do
      conn = post(conn, Routes.session_path(conn, :signup), user: %{name: "some name", email: user.email, password: "Password123"})
      assert %{
        "errors" => %{
          "email" => ["has already been taken"],
        }
      } = json_response(conn, 422)
    end

    test "renders errors when bad password", %{conn: conn, user: %User{} = _user} do
      conn = post(conn, Routes.session_path(conn, :signup), user: %{name: "some name", email: "test@test.com", password: "pass"})
      assert %{
        "errors" => %{
          "password" => ["at least one digit or punctuation character",
          "at least one upper case character",
          "should be at least 8 character(s)"]
        }
      } = json_response(conn, 422)

    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
