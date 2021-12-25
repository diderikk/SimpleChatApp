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

user = Repo.insert!(%User{name: "Test", email: "test123@test.com", password: "Password123"}) |> Repo.preload(:chats)
Repo.insert!(%User{name: "Test1", email: "test13@test.com", password: "Password123"})
chat = Repo.insert!(%Chat{})

user = Ecto.Changeset.change(user) |> Ecto.Changeset.put_assoc(:chats, [chat])
Repo.update! user
