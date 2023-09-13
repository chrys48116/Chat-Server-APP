defmodule ChatServerApp.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user_id_from, references(:users, on_delete: :nothing)
      add :user_id_to, references(:users, on_delete: :nothing)
      add :content, :string
      add :content_type, :string

      timestamps()
    end
  end
end
