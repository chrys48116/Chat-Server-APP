defmodule ChatServerApp.Models.Rooms.Schema.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :room_name, :string
    has_many :group_message, ChatServerApp.Models.Models.Schema.Messages.Schema.GroupMessage, foreign_key: :room_id
    many_to_many :users, ChatServerApp.Models.Models.Schema.Users.Schema.User, join_through: ChatServerApp.Models.Rooms.Schema.UserRoom

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:room_name])
    |> validate_required([:room_name])
  end
end
