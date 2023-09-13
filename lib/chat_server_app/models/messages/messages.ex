defmodule ChatServerApp.Models.Messages do
  alias ChatServerApp.Models.Messages.Repositories.Database
  alias ChatServerApp.Models.Users
  alias ChatServerApp.Models.Rooms

  def send_message(user_id_from, user_id_to, content, content_type) do
    case {Users.user_exists(user_id_from), Users.user_exists(user_id_to)} do
      {{:error, _}, {:error, _}} ->
        {:error, :user_not_found}

      _ ->
        username = Users.get_user(user_id_to).username
        Database.send_message(user_id_from, user_id_to, content, content_type)
        {:ok, "Message sent to user #{username}: #{content}"}
    end
  end

  def get_pending_messages(user_id) do
    case Users.user_exists(user_id) do
      {:error, _} ->
        {:error, :user_not_found}

      _ ->
        messages = Database.get_pending_messages(user_id)
        response = Enum.reduce(messages, [], fn message, acc ->
          ["Received message from #{message.user_id_from} at #{message.timestamp}: #{message.content}" | acc]
        end)
        Database.delete_pending_messages(user_id)
        {:ok, response}
    end
  end

  def send_group_message(room_id, user_id, content, content_type) do
    case {Users.user_exists(user_id), Rooms.get_room(room_id)} do
      {{:error, _}, nil} ->
        {:error, :user_not_found, :room_not_found}

      {{:ok, _}, nil} ->
        {:error, :room_not_found}

      {{:error, _}, _} ->
        {:error, :user_not_found}

      _ ->
        username = Users.get_user(user_id).username
        Database.send_group_message(room_id, user_id, content, content_type)
        {:ok, "Message sent of #{username}: #{content}"}
    end
  end

  def get_group_messages(room_id) do
    case Rooms.get_room(room_id) do
      nil ->
        {:error, :room_not_found}

      _ ->
        messages = Database.get_group_messages(room_id)
        response = Enum.reduce(messages, [], fn message, acc ->
          ["Received message from #{Users.get_user(message.user_id).username} at #{message.timestamp}: #{message.content}" | acc]
        end)
        {:ok, response}
    end
  end
end
