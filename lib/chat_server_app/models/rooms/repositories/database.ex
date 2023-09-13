defmodule ChatServerApp.Models.Rooms.Repositories.Database do
  import Ecto.Query
  alias ChatServerApp.Models.Rooms.Schema.{Room, UserRoom}
  alias ChatServerApp.Repo

  def create_room(room_name) do
    Repo.insert(Room.changeset(%Room{}, %{room_name: room_name}))
  end

  def delete_room(room_id) do
    Repo.delete!(from r in Room, where: r.id == ^room_id)
  end

  def join_room(user_id, room_id) do
    Repo.insert(UserRoom.changeset(%UserRoom{}, %{user: user_id, room: room_id}))
  end

  def get_room(room_id) do
    Repo.get(Room, room_id)
  end
end
