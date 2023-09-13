defmodule ChatServerApp.Models.Messages.Schema.PendingMessages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pending_messages" do
    field :content, :string
    field :content_type, :string
    belongs_to :from_user, ChatServerApp.Models.Users.Schema.User, foreign_key: :user_id_from
    belongs_to :to_user, ChatServerApp.Models.Users.Schema.User, foreign_key: :user_id_to

    timestamps()
  end

    @doc false
    def changeset(message, attrs) do
      message
      |> cast(attrs, [:content, :user_id_from, :user_id_to, :content_type])
      |> validate_required([:content, :user_id_from, :user_id_to])
    end
end
