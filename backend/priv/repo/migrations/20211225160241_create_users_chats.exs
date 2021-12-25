defmodule Backend.Repo.Migrations.CreateUsersChats do
  use Ecto.Migration

  def change do
    create table(:users_chats) do
      add :user_id, references(:users)
      add :chat_id, references(:chats)
      add :has_accepted, :boolean, default: false, null: false
    end
  end
end
