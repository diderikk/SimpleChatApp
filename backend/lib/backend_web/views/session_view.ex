defmodule BackendWeb.SessionView do
  use BackendWeb, :view

  alias Backend.Accounts.User
  alias BackendWeb.ErrorView

  def render("session.json", %{token: token}), do: %{token: token}

  def render("401.json", %{reason: reason}) do
    render_one(reason, ErrorView, "401.json")
  end

  def render("user_created.json", %{token: token, user: %User{} = user}) do
    %{
      token: token,
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      }
    }
  end

  def render("channel.json", %{token: token, user_id: user_id}),
    do: %{token: token, user_id: user_id}

  def render("403.json", _params) do
    %{
      error: "Forbidden"
    }
  end
end
