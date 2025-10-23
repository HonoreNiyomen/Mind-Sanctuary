defmodule MindSanctuary.Resources do
  @moduledoc false
  import Ecto.Query, warn: false
  alias MindSanctuary.Repo

  alias MindSanctuary.Resources.Resource

  def list_resources(opts \\ []) do
    query = from r in Resource, order_by: [asc: r.title]

    case Keyword.get(opts, :search) do
      nil -> Repo.all(query)
      "" -> Repo.all(query)
      q ->
        like = "%" <> q <> "%"
        from(r in query, where: ilike(r.title, ^like) or ilike(r.description, ^like))
        |> Repo.all()
    end
  end

  def get_resource!(id), do: Repo.get!(Resource, id)

  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  def change_resource(%Resource{} = resource, attrs \\ %{}) do
    Resource.changeset(resource, attrs)
  end
end
