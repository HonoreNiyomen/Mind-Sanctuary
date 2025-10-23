defmodule MindSanctuary.Resources do
  @moduledoc false

  import Ecto.Query
  alias MindSanctuary.Repo
alias MindSanctuary.Resources.Resource
  # current_scope must be passed as first argument (per app guidelines)
  def list_resources(current_scope) do
    from(s in Resource, where: ^current_scope.user.role in s.access_level  or ^"public" in s.access_level, order_by: [asc: s.inserted_at])
    |> Repo.all()
  end

  def list_resources_in_range(current_scope, from_dt, to_dt) do
    from(s in Resource,
      where: s.user_id == ^current_scope.user.id,
      where: s.inserted_at >= ^from_dt and s.inserted_at <= ^to_dt,
      order_by: [asc: s.inserted_at]
    )
    |> Repo.all()
  end

  def change_resource(%Resource{} = schedule, attrs \\ %{}) do
    Resource.changeset(schedule, attrs)
  end

  def create_resource(attrs) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end
end
