defmodule Backend.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :backend,
  module: Backend.Guardian,
  error_handler: Backend.AuthErrorHandler

  import Guardian.Plug, only: [find_token_from_cookies: 2]
  alias Backend.Accounts.User

  # Finds the access token in header or creates a new from refresh token in cookie
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, refresh_from_cookie: []

  # Checks if the token is valid
  plug Guardian.Plug.EnsureAuthenticated

  # Checks if there was created a new access token from cookie and sends a message with forbidden status
  # and the new token as body
  plug Backend.Plug.InterceptRefresh

  # Louds resources defined from jwt.ex and resource_from_claims function
  plug Guardian.Plug.LoadResource

  plug :verify_token_version





  defp verify_token_version(conn, opts) do
    {:ok, token} = find_token_from_cookies(conn, opts)
    {:ok, %{"token_version" => token_version_from_token}} = Backend.Guardian.decode_and_verify(token, %{})
    %User{token_version: user_token_version} = Backend.Guardian.Plug.current_resource(conn)
    if token_version_from_token == user_token_version do
       conn
    else
      conn
      |> Guardian.Plug.Pipeline.fetch_error_handler!(opts)
      |> apply(:auth_error, [conn, {:unauthenticated, "Token version from cookie token did not match user token"}, opts])
      |> Guardian.Plug.maybe_halt(opts)
    end

  end
end
