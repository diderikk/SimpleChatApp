defmodule Backend.AuthErrorHandler do
  @moduledoc """
    Handler for errors during the auth pipeline
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @spec auth_error(Plug.Conn.t(), {any, any}, any) :: Plug.Conn.t()
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: String.capitalize(to_string(type))})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
