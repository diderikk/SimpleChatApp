defmodule Backend.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some.email@gmail#{System.unique_integer([:positive])}.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        is_admin: true,
        name: "some name",
        password_hash: "some password_hash",
        password: "Password123",
        salt: "some salt",
        token_version: 42
      })
      |> Backend.Accounts.create_user()

    user
  end
end
