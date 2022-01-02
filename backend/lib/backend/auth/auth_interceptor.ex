defmodule Backend.Plug.InterceptRefresh do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    with {:ok, token} <- fetch_token_from_header(conn, opts),
         {:ok, %{"typ" => "access", "token_version" => _token_version}} <-
           Backend.Guardian.decode_and_verify(token) do
      conn
    else
      _error ->
        token = Guardian.Plug.current_token(conn)
        body = Jason.encode!(%{new_token: token})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, body)
        |> halt()
    end
  end

  defp fetch_token_from_header(conn, opts) do
    header_name = Keyword.get(opts, :header_name, "authorization")

    case get_req_header(conn, header_name) do
      ["Bearer " <> token | _headers] -> {:ok, token}
      error -> error
    end
  end
end
