defmodule MindSanctuary.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :title, :string, null: false
      add :description, :text
      add :url, :string, null: false
      add :type, :string, null: false
      add :tags, {:array, :string}, null: false, default: []

      timestamps()
    end

    create index(:resources, [:type])
    create index(:resources, [:tags], using: :gin)
    create unique_index(:resources, [:url])
  end
end
