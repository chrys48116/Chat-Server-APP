defmodule ChatServerApp.Models.Users.Repositories.Database do
  import Ecto.Query
  alias ChatServerApp.Models.Users.Schema.User
  alias ChatServerApp.Repo

  def insert_user(username) do
    Repo.insert(User.changeset(%User{}, %{username: username}))
  end

  def delete_user(user_id) do
    Repo.delete!(from u in User, where: u.id == ^user_id)
  end

  def get_all_users(), do: Repo.all(User)

  def get_user(user_id), do: Repo.get(User, user_id)

  def user_exists(user_id), do: Repo.one(from u in User, where: u.id == ^user_id)

end
