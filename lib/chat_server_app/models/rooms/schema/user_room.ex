defmodule ChatServerApp.Models.Rooms.Schema.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_chat_room" do
    belongs_to :user, ChatServerApp.Models.Users.Schema.User
    belongs_to :room, ChatServerApp.Models.Rooms.Schema.Room
  end

  @doc false
  def changeset(user_room, attrs) do
    user_room
    |> cast(attrs, [])
    |> cast_assoc(:user)
    |> cast_assoc(:room)
    |> validate_required([:user, :room])
  end
end
