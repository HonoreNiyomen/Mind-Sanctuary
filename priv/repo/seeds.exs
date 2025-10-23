# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MindSanctuary.Repo.insert!(%MindSanctuary.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

######### ADMIN SEED ACCOUNT #################
{:ok, admin} =
  %{
    email: "admin@mindsanctuary.edu",
    username: UniqueNamesGenerator.generate([:adjectives, :animals]),
    role: "admin"
  }
  |> MindSanctuary.Accounts.register_user()

admin
|> MindSanctuary.Accounts.change_user_password(%{
  password: "admin@mindsanctuary.edu",
  password_confirmation: "admin@mindsanctuary.edu"
})

######### STUDENT SEED ACCOUNT #################
{:ok, student} =
  %{
    email: "student@mindsanctuary.edu",
    username: UniqueNamesGenerator.generate([:adjectives, :animals]),
    role: "student"
  }
  |> MindSanctuary.Accounts.register_user()

student
|> MindSanctuary.Accounts.change_user_password(%{
  password: "student@mindsanctuary.edu",
  password_confirmation: "student@mindsanctuary.edu"
})

######### VOLUNTEER SEED ACCOUNT #################
{:ok, volunteer} =
  %{
    email: "volunteer@mindsanctuary.edu",
    username: UniqueNamesGenerator.generate([:adjectives, :animals]),
    role: "volunteer"
  }
  |> MindSanctuary.Accounts.register_user()

volunteer
|> MindSanctuary.Accounts.change_user_password(%{
  password: "volunteer@mindsanctuary.edu",
  password_confirmation: "volunteer@mindsanctuary.edu"
})
