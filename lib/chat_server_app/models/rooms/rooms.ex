defmodule ChatServerApp.Models.Rooms do
  alias ChatServerApp.Models.Rooms.Repositories.Database
  alias ChatServerApp.Models.Users

  def create_room(room_name) do
    Database.create_room(room_name)
    {:ok, "Room #{room_name} created"}
  end

  def delete_room(room_id) do
    Database.delete_room(room_id)
  end

  def join_room(user_id, room_id) do
    case get_room(room_id) do
      nil ->
        {:error, "Room does not exists"}

      _ ->
        username = Users.get_user(user_id).username
        room_name = get_room(room_id).room_name

        Database.join_room(user_id, room_id)
        {:ok, "User #{username} joined in #{room_name}"}
    end
  end

  def get_room(room_id) do
    Database.get_room(room_id)
  end
end
