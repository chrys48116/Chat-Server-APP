defmodule ChatServerApp.Models.Messages.Schema.GroupMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_messages" do
    field :content, :string
    field :content_type, :string

    belongs_to :user, ChatServerApp.Models.Users.Schema.User
    belongs_to :room, ChatServerApp.Models.Rooms.Schema.Room
    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:content, :user_id, :room_id, :content_type])
    |> validate_required([:content, :user_id, :room_id])
  end
end
