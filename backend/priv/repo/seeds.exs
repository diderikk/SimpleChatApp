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
alias Backend.Accounts
alias Backend.Repo
alias Backend.Medias

Accounts.create_user(%{name: "Test", email: "test123@test.com", password: "Password123"})
user1 = Repo.get(User, 1)
{:ok, user2} = Accounts.create_user(%{name: "Test1", email: "test13@test.com", password: "Password123"})
chat1 = Accounts.add_user_chat(user1.id, [user2.email])

Medias.persist_message(user1.id, chat1.id, %{content: "Test message"})
