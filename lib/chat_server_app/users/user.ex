defmodule ChatServerApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string

    has_many :messages_from, ChatServerApp.Messages.Message, foreign_key: :user_id_from
    has_many :messages_to, ChatServerApp.Messages.Message, foreign_key: :user_id_to
    has_many :group_messages, ChatServerApp.Messages.GroupMessage, foreign_key: :user_id_from
    many_to_many :chat_rooms, ChatServerApp.Messages.ChatRoom, join_through: "user_chat_rooms"
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end
end
