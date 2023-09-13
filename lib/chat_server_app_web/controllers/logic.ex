defmodule ChatServer.Logic do

  import Ecto.Query

  alias ChatServerApp.Repo
  alias ChatServerApp.Models.Rooms.Schema.{Room, UserRoom}
  alias ChatServerApp.Models.Users.Schema.User
  alias ChatServerApp.Models.Messages.Schema.{GroupMessage, Message, PendingMessages}
  def get() do
    # Repo.all(User)
    # Repo.all(Room)
    # Repo.all(UserRoom)
    # Repo.all(GroupMessage)
    # Repo.all(Message)
    Repo.all(PendingMessages)
  end

  def user_exists(user_id_from, user_id_to) do
    case {Repo.one(from u in User, where: u.id == ^user_id_from), Repo.one(from u in User, where: u.id == ^user_id_to)} do
      {nil, _} ->  {:error, "User with id #{user_id_from} not found"}
      {_, nil} ->  {:error, "User with id #{user_id_to} not found"}
      {_, _} -> {:ok}
    end
  end

  def create_room(room_name) do
    Repo.insert(Room.changeset(%Room{}, %{room_name: room_name}))
    {:ok, "Room #{room_name} created"}
  end

  def join_room(user_id, room_id) do
    case Repo.get(Room, room_id) do
      nil ->
        {:error, "Room does not exists"}

      _ ->
        username = Repo.one(
          from u in User,
          select: u.username,
          where: u.id == ^user_id
          )
        room_name = Repo.one(
          from r in Room,
          select: r.room_name,
          where: r.id == ^room_id
        )

        Repo.insert(UserRoom.changeset(%UserRoom{}, %{user: user_id, room: room_id}))
        {:ok, "User #{username} joined in #{room_name}"}
    end
  end

  def send_group_message(room_id, user_id, content, content_type) do
    case Repo.get(Room, room_id) do
      nil ->
        {:error, "Room does not exists"}

      _ ->
        username = Repo.one(from u in User, select: u.username, where: u.id == ^user_id)
        Repo.insert(GroupMessage.changeset(%GroupMessage{}, %{user_id: user_id, content: content, content_type: content_type, room_id: room_id, timestamp: DateTime.utc_now()}))
        {:ok, "Message sent of #{username}: #{content}"}
    end
  end

  def send_message(user_id_from, user_id_to, content, content_type) do
    case user_exists(user_id_from, user_id_to) do
      {:error, response} ->
        {:error, response}

      {:ok} ->
        username = Repo.one(from u in User, select: u.username, where: u.id == ^user_id_to)
        Repo.insert(Message.changeset(%Message{}, %{user_id_from: user_id_from, user_id_to: user_id_to, content: content, content_type: content_type, timestamp: DateTime.utc_now()}))
        Repo.insert(PendingMessages.changeset(%PendingMessages{}, %{user_id_from: user_id_from, user_id_to: user_id_to, content: content, content_type: content_type, timestamp: DateTime.utc_now()}))
        {:ok, "Message sent to User #{username}: #{content}"}
    end
  end

  def receive_messages(room_id) do
    messages = Repo.all(from m in GroupMessage,
          join: u in assoc(m, :user),
          where: m.room_id == ^room_id,
          order_by: [desc: m.inserted_at],
          select: %{content: m.content, timestamp: m.inserted_at, user_id: u.id})

    response = Enum.reduce(messages, [], fn message, acc ->
      ["Received message from #{message.user_id} at #{message.timestamp}: #{message.content}" | acc]
    end)
    {:ok, response}
  end

  def get_pending_messages(user_id) do
    messages = Repo.all(from m in PendingMessages,
          where: m.user_id_to == ^user_id,
          order_by: [desc: :inserted_at],
          select: %{content: m.content, timestamp: m.inserted_at, user_id_from: m.user_id_from})

    response = Enum.reduce(messages, [], fn message, acc ->
      ["Received message from #{message.user_id_from} at #{message.timestamp}: #{message.content}" | acc]
    end)

    Repo.delete_all(from m in PendingMessages, where: m.user_id_to == ^user_id)
    {:ok, response}
  end

  def add_user(username), do: Repo.insert(User.changeset(%User{}, %{username: username}))

  def remove_user(user_id), do: Repo.delete_by(User, [user_id: user_id])

end
