defmodule ChatServerApp.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :room_name, :string

      timestamps()
    end
  end
end
