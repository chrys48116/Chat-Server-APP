defmodule ChatServerApp.Messages.GroupMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_messages" do
    field :content, :string
    field :content_type, :string

    belongs_to :user_id_from, ChatServerApp.Users.User
    belongs_to :room_name, ChatServerApp.Rooms.Room
    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:message, :user_id, :room_id])
    |> validate_required([:message, :user_id, :room_id])
  end
end
