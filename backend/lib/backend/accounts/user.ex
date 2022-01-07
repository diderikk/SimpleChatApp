defmodule Backend.Accounts.User do
  @moduledoc """
    Schema for User struct
  """
  use Ecto.Schema
  import Ecto.Changeset

  @salt_length 32

  @derive {Inspect, only: [:id, :email, :name, :chats]}
  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :salt, :string
    field :token_version, :integer, default: 0
    many_to_many :chats, Backend.Medias.Chat, join_through: "users_chats", on_delete: :delete_all
    has_many :messages, Backend.Medias.Message, on_delete: :nilify_all


    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_admin, :name, :token_version])
    |> validate_required([:email, :password_hash, :salt, :is_admin, :name, :token_version])
    |> validate_number(:token_version, greater_than_or_equal_to: 0)
    |> validate_length(:password_hash, min: 10)
    |> validate_length(:salt, is: 32)
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> validate_required(:name)
    |> validate_password()
    |> validate_email()
    |> put_password_hash_and_salt()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, min: 6, max: 160)
    |> unsafe_validate_unique(:email, Backend.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 80)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
  end

  defp put_password_hash_and_salt(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        salt =
          Pbkdf2.gen_salt(salt_len: @salt_length)
          |> Base.encode64()
          |> binary_part(0, @salt_length)

        changeset
        |> put_change(:password_hash, Pbkdf2.hash_pwd_salt(password <> salt, rounds: 200_000))
        |> put_change(:salt, salt)

      _ -> changeset
    end
  end

  def valid_password?(password, %Backend.Accounts.User{password_hash: hashed_password, salt: salt})
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password <> salt, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end
end
