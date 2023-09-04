defmodule ChatServer.Logic do

  #alias ChatServer.Messages

  def user_exists(user_id_from, user_id_to, state) do
    case {Map.get(state.users, user_id_from), Map.get(state.users, user_id_to)} do
      {nil, _} ->  {:error, "User with id #{user_id_from} not found"}
      {_, nil} ->  {:error, "User with id #{user_id_to} not found"}
      {_, _} -> {:ok}
    end
  end

  def join_room(user_id, room_name, state) do
    case Map.get(state.rooms, room_name) do
      nil ->
        {:error, "Room does not exists", state}

      room_users ->
        username = Map.get(state.users, user_id, "Unknown")
        rooms = Map.put(state.rooms, room_name, [%{user_id: user_id, username: username} | room_users])
        {:ok, "User #{username} joined #{room_name}", %{state | rooms: rooms}}
    end
  end

  def send_group_message(room_name, user_id_from, content, state) do
    case Map.get(state.rooms, room_name) do
      nil ->
        {:error, "Room does not exist.", state}

      room_users ->
        new_message = %{user_id_from: user_id_from, content: content, room: room_name, timestamp: DateTime.utc_now()}
        room_messages = Map.get(state.room_messages, room_name, [])
        new_state = %{state | room_messages: Map.put(state.room_messages, room_name, [new_message | room_messages])}

        # Notify all users in the room about the new message
        response = Enum.reduce(room_users, "", fn %{user_id: _user_id, username: username}, acc ->
          acc <> "Message sent of #{username}: #{content}"
        end)
        {:ok, response, new_state}
    end
  end

  def send_message(user_id_from, user_id_to, content, state) do
    case user_exists(user_id_from, user_id_to, state) do
      {:error, error} ->
        IO.puts(error)
        {:error, "User not exists", state}

      {:ok} ->
        new_message = %{user_id_from: user_id_from, user_id_to: user_id_to, content: content, timestamp: DateTime.utc_now()}
        state_message = %{state | messages: [new_message | state.messages]}
        new_state = %{state_message | pending_messages: [new_message | state.pending_messages]}

        # Notify the user that a new message has been sent
        {:ok, "Message sent to User #{Map.get(state.users, user_id_to)}: #{content}", new_state}
    end
  end

  def receive_messages(room_name, state) do
    messages =
    Map.get(state.room_messages, room_name, %{})
    response = Enum.reduce(messages, "", fn message, acc ->
      acc <> "Received message from #{Map.get(state.users, message.user_id_from)} at #{message.timestamp}: #{message.content}"
    end)
    new_state = %{state | room_messages: messages}
    {:ok, response, new_state}
  end

  def get_pending_messages(user_id, state) do
    {messages_to_user, remaining_messages} =
      Enum.split_with(state.pending_messages, fn message ->
        message.user_id_to == user_id
      end)
    response = Enum.reduce(messages_to_user, "", fn message, acc ->
      acc <> "Received message from #{Map.get(state.users, message.user_id_from)} at #{message.timestamp}: #{message.content}"
    end)
    new_state = %{state | pending_messages: remaining_messages}
    {:ok, response, new_state}
  end

  def add_user(user_id, username, state) do
    users = Map.put(state.users, user_id, username)
    {:ok, "User created", %{state | users: users}}
  end

  def remove_user(user_id, state) do
    users = Map.delete(state.users, user_id)
    {:ok, "User deleted", %{state | users: users}}
  end
end
