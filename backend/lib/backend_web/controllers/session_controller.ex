defmodule BackendWeb.SessionController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.User

  action_fallback BackendWeb.FallbackController

  @spec signin(any, map) :: {:error, binary()} | Plug.Conn.t()
  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, access_token, refresh_token} <- Accounts.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> put_refresh_cookie(refresh_token)
      |> render("session.json", token: access_token)
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("401.json", reason: reason)

      _ ->
        conn
        |> put_status(:unauthorized)
        |> render("401.json", reason: "Unauthorized")
    end
  end

  @spec signup(Plug.Conn.t(), map) :: Plug.Conn.t()
  def signup(conn, %{
        "user" => %{"email" => email, "name" => _name, "password" => password} = user_params
      }) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      with {:ok, access_token, refresh_token} <- Accounts.authenticate(email, password) do
        conn
        |> put_status(:created)
        |> put_refresh_cookie(refresh_token)
        |> render("user_created.json", token: access_token, user: user)
      end
    end
  end

  @spec channel_token(Plug.Conn.t(), map) :: Plug.Conn.t()
  def channel_token(conn, %{"id" => chat_id}) do
    with user <- Backend.Guardian.Plug.current_resource(conn),
         {:ok, channel_token, _claims} <- Backend.Guardian.create_channel_token(user, chat_id) do
          if Backend.Authorization.authorize_chat(user, String.to_integer(chat_id)) do
            render(conn, "channel.json", token: channel_token, user_id: user.id)
          else
            conn
            |> put_status(:forbidden)
            |> render("403.json")
          end
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> render("401.json", reason: "Unauthorized")
    end
  end

  @spec put_refresh_cookie(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def put_refresh_cookie(conn, refresh_token) do
    conn
    |> put_resp_cookie("guardian_default_token", refresh_token, http_only: true, encrypt: true)
  end
end
