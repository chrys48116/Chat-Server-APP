defmodule ChatServerApp.Repo do
  use Ecto.Repo,
    otp_app: :chat_server_app,
    adapter: Ecto.Adapters.Postgres
end
