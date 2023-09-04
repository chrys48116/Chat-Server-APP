defmodule ChatServerAppWeb.Router do
  use ChatServerAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatServerAppWeb do
    pipe_through :api

    post "/send_message", ChatController, :send_message
    post "/send_group_message", ChatController, :send_group_message
    post "/create_room", ChatController, :create_room
    post "/join_room", ChatController, :join_room
    post "/add_user", ChatController, :add_user
    post "/remove_user", ChatController, :remove_user
    get "/receive_messages", ChatController, :receive_messages
    get "/get_pending_messages", ChatController, :get_pending_messages
    get "/get_all_users", ChatController, :get_all_users
    get "/get_all_messages", ChatController, :get_all_messages
    get "/get_all_chats", ChatController, :get_all_chats
    get "/get_users_in_room", ChatController, :get_users_in_room
    get "/get_messages_in_room", ChatController, :get_messages_in_room
    get "/", PageController, :home
  end

end
