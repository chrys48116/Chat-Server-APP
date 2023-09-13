defmodule ChatServerApp.Models.Messages.Schema.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :content_type, :string
    belongs_to :from_user, ChatServerApp.Models.Users.Schema.User
    belongs_to :to_user, ChatServerApp.Models.Users.Schema.User
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :from_user_id, :to_user_id, :content_type])
    |> validate_required([:content, :from_user_id, :to_user_id])
  end
end
