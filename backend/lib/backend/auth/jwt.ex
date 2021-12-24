defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  alias Backend.Accounts.User
  alias Backend.Accounts
  alias Backend.Guardian

  @impl true
  def subject_for_token(%User{id: user_id}, _claims) do
    sub = to_string(user_id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @impl true
  def resource_from_claims(%{"sub" => user_id}) do
    user = Accounts.get_user!(user_id)
    {:ok, user}
  end

  @impl true
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  # def verify_claims(%{"email" => email, "sub" => user_id} = claims, _options) do
  #   if user = Accounts.get_user!(user_id) do
  #     if user.email == email do
  #       {:ok, claims}
  #     else
  #       {:error, "Bad token"}
  #     end
  #   else
  #     {:error, "Invalid user_id"}
  #   end
  # end

  @doc """
  Creates an access token and a refresh token for a given user

  ## Example

      iex> create_access_and_refresh_tokens(user)
      {access_token, refresh_token}
  """
  @spec create_access_and_refresh_tokens(map()) :: {binary(), binary()}
  def create_access_and_refresh_tokens(%User{} = user) do
    access_token =
      Guardian.encode_and_sign(user, %{token_version: user.token_version}, token_type: "access") |> elem(1)

    refresh_token =
      Guardian.encode_and_sign(user, %{token_version: user.token_version}, token_type: "refresh") |> elem(1)

    {access_token, refresh_token}
  end
end
