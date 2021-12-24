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

  scope "/api", BackendWeb do
    pipe_through :api

    post "/signin", SessionController, :signin
    post "/signup", SessionController, :signup

    pipe_through :auth
    resources "/users", UserController, except: [:new, :edit, :create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
    end
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
end
