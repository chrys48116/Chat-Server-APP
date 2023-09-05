defmodule ChatServerApp.Repo.Migrations.CreateGroupMessage do
  use Ecto.Migration

  def change do
    create table("group_messages") do
      add :id_room, references("rooms", on_delete: :nothing)
      add :user_id_from, references("users", on_delete: :nothing)
      add :content, :string
      add :content_type, :string

      timestamps()
    end
  end
end
