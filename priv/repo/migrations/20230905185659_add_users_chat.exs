defmodule ChatServerApp.Repo.Migrations.AddUsersChat do
  use Ecto.Migration

  def change do
    create table(:user_chat_room) do
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end
  end
end
