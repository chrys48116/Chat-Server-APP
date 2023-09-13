defmodule ChatServerApp.Models.Messages.Repositories.Database do
  import Ecto.Query
  alias ChatServerApp.Models.Messages.Schema.{Message, GroupMessage, PendingMessages}
  alias ChatServerApp.Repo

  def send_message(user_id_from, user_id_to, content, content_type) do
    Repo.insert(Message.changeset(%Message{}, %{user_id_from: user_id_from, user_id_to: user_id_to, content: content, content_type: content_type, timestamp: DateTime.utc_now()}))
    Repo.insert(PendingMessages.changeset(%PendingMessages{}, %{user_id_from: user_id_from, user_id_to: user_id_to, content: content, content_type: content_type, timestamp: DateTime.utc_now()}))
  end

  def send_group_message(room_id, user_id, content, content_type) do
    Repo.insert(GroupMessage.changeset(%GroupMessage{}, %{user_id: user_id, content: content, content_type: content_type, room_id: room_id, timestamp: DateTime.utc_now()}))
  end

  def get_group_messages(room_id) do
    Repo.all(from m in GroupMessage,
          join: u in assoc(m, :user),
          where: m.room_id == ^room_id,
          order_by: [desc: m.inserted_at],
          select: %{content: m.content, timestamp: m.inserted_at, user_id: u.id})
  end

  def get_pending_messages(user_id) do
    Repo.all(from m in PendingMessages,
          where: m.user_id_to == ^user_id,
          order_by: [desc: :inserted_at],
          select: %{content: m.content, timestamp: m.inserted_at, user_id_from: m.user_id_from})
  end

  def delete_pending_messages(user_id) do
    Repo.delete_all(from m in PendingMessages, where: m.user_id_to == ^user_id)
  end

  def get_messages() do
    Repo.all(Message)
  end
end
