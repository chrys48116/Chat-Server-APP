defmodule ChatServerApp.Models.Users.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string

    has_many :messages_from, ChatServerApp.Models.Messages.Schema.Message, foreign_key: :from_user_id
    has_many :messages_to, ChatServerApp.Models.Messages.Schema.Message, foreign_key: :to_user_id
    has_many :group_messages, ChatServerApp.Models.Messages.Schema.GroupMessage, foreign_key: :user_id
    has_many :user_rooms, ChatServerApp.Models.Rooms.Schema.UserRoom, foreign_key: :user_id
    has_many :chat_rooms, through: [:user_rooms, :room_name]
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end
end
