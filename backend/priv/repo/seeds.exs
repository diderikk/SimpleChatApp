# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Backend.Accounts.User
alias Backend.Repo
alias Backend.Medias.Chat
alias Backend.Medias

user1 = Repo.insert!(%User{name: "Test", email: "test123@test.com", password: "Password123"}) |> Repo.preload(:chats)
user2 = Repo.insert!(%User{name: "Test1", email: "test13@test.com", password: "Password123"})
chat1 = Repo.insert!(%Chat{})

user1 = Ecto.Changeset.change(user1) |> Ecto.Changeset.put_assoc(:chats, [chat1])
user1 = Repo.update! user1
Medias.send_message(user1, chat1.id, %{content: "Test message"})
