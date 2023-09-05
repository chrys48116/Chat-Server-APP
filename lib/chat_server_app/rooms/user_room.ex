defmodule ChatServerApp.Rooms.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_chat_room" do
    belongs_to :user_id, ChatServerApp.Users.User
    belongs_to :room_name, ChatServerApp.Rooms.Room
  end

  @doc false
  def changeset(user_room, attrs) do
    user_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
