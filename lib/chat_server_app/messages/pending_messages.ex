defmodule ChatServerApp.Messages.PendingMessages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pending_messages" do
    schema "messages" do
      field :content, :string
      field :content_type, :string
      belongs_to :user_id_from, ChatServerApp.Users.User
      belongs_to :user_id_to, ChatServerApp.Users.User
      timestamps()
    end

    @doc false
    def changeset(message, attrs) do
      message
      |> cast(attrs, [:message, :user_id, :room_id])
      |> validate_required([:message, :user_id, :room_id])
    end
end
