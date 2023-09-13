defmodule ChatServerApp.Models.Users do
  alias ChatServerApp.Models.Users.Repositories.Database

  def insert_user(username) do
    Database.insert_user(username)
  end

  def delete_user(user_id) do
    Database.delete_user(user_id)
  end

  def get_all_users(), do: Database.get_all_users()

  def get_user(user_id), do: Database.get_user(user_id)

  def user_exists(user_id) do
    case Database.user_exists(user_id) do
      nil -> {:error, :user_not_found}
      _ -> {:ok}
    end
  end

end
