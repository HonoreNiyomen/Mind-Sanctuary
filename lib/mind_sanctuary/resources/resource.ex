defmodule MindSanctuary.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :title, :string
    field :description, :string
    field :url, :string
    field :type, :string
    field :tags, {:array, :string}, default: []

    timestamps()
  end

  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:title, :description, :url, :type, :tags])
    |> validate_required([:title, :url, :type])
    |> validate_length(:title, min: 3)
    |> validate_format(:url, ~r/^https?:\/\//)
    |> unique_constraint(:url)
  end
end
