defmodule ChatServerApp.Repo.Migrations.CreateGroupMessage do
  use Ecto.Migration

  def change do
    create table(:group_messages) do
      add :room_id, references(:rooms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :content, :string
      add :content_type, :string

      timestamps()
    end
  end
end
