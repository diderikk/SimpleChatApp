defmodule Backend.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :chat_id, references(:chats), null: false, on_delete: :delete_all
      add :user_id, references(:users), null: false, on_delete: :delete_all

      timestamps()
    end
  end
end
