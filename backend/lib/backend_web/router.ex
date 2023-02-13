defmodule BackendWeb.Router do
  use BackendWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_cookies, encrypted: ["guardian_default_token"]
    plug :decrypt_request_cookies
  end

  pipeline :auth do
    plug Backend.AuthAccessPipeline
  end

  pipeline :dashboard_auth do
    plug :basic_auth
  end

  scope "/api/simplechat", BackendWeb do
    pipe_through :api

    post "/signin", SessionController, :signin
    post "/signup", SessionController, :signup
    get "/hello/:name", HelloController, :hello

    if Mix.env() not in [:test], do: pipe_through(:auth)
    get "/users/chats", UserController, :chat_list
    post "/users/chats", UserController, :create_chat
    put "/users/invited_chats/:id", UserController, :accept_chat
    delete "/users/invited_chats/:id", UserController, :decline_chat
    get "/chats/:id/channel_token", SessionController, :channel_token
    get "/chats/:id/:page", ChatController, :page
    get "/chats/:id", ChatController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery, :dashboard_auth]

    live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp decrypt_request_cookies(conn, _opts) do
    conn
    |> Map.put(:req_cookies, conn.cookies)
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{error: message}) |> halt()
  end

  defp handle_errors(conn, _) do
    conn |> put_status(400) |> json(%{error: "Bad Request"}) |> halt()
  end

  defp basic_auth(conn, _opts) do
    username = System.fetch_env!("DASHBOARD_USERNAME")
    password = System.fetch_env!("DASHBOARD_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
