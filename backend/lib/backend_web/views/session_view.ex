defmodule BackendWeb.SessionView do
  use BackendWeb, :view

  alias Backend.Accounts.User

  def render("session.json", %{token: token}), do: %{token: token}

  def render("user_created.json", %{token: token, user: %User{} = user}) do
    %{
      token: token,
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
      }
    }
  end
end
