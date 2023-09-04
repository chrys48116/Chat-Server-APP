defmodule ChatServerAppWeb.ChatController do
  use ChatServerAppWeb, :controller

  alias ChatServer
  def send_message(conn, %{"user_id_from" => user_id_from, "user_id_to" => user_id_to, "content" => content}) do
    response=
    ChatServer.send_message(%{user_id_from: user_id_from, user_id_to: user_id_to, content: content})
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def send_group_message(conn, %{"room_name" => room_name, "user_id_from" => user_id_from, "content" => content}) do
    response =
    ChatServer.send_group_message(%{room_name: room_name, user_id_from: user_id_from, content: content})
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def receive_messages(conn, %{"room_name" => room_name}) do
    response =
    ChatServer.receive_messages(room_name)
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_pending_messages(conn, %{"user_id" => user_id}) do
    response =
    ChatServer.get_pending_messages(user_id)
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def create_room(conn, %{"room_name" => room_name}) do
    response =
    ChatServer.create_room(room_name)
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def join_room(conn, %{"user_id" => user_id, "room_name" => room_name}) do
    response =
    ChatServer.join_room(user_id, room_name)
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def add_user(conn, %{"user_id" => user_id, "username" => username}) do
    response =
    ChatServer.add_user(user_id, username)
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def remove_user(conn, %{"user_id" => user_id}) do
    response =
    ChatServer.remove_user(user_id)
    |>Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_all_users(conn, _params) do
    response =
    ChatServer.get_all_users()
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_all_messages(conn, _params) do
    response =
    ChatServer.get_all_messages()
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_all_chats(conn, _params) do
    response =
    ChatServer.get_all_chats()
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_users_in_room(conn, %{"room_name" => room_name}) do
    response =
    ChatServer.get_users_in_room(room_name)
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  def get_messages_in_room(conn, %{"room_name" => room_name}) do
    response =
    ChatServer.get_messages_in_room(room_name)
    |> Jason.encode!()
    send_resp(conn, 200, response)
  end
end
