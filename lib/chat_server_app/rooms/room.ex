defmodule ChatServerApp.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :room_name, :string
    has_many :group_message, ChatServerApp.Messages.GroupMessage
    many_to_many :users, ChatServerApp.Users.User, join_through: "user_chat_room"
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:room_name])
    |> validate_required([:room_name])
  end
end
