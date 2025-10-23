defmodule MindSanctuaryWeb.ResourcesLive.FormComponent do
  use MindSanctuaryWeb, :live_component
  alias MindSanctuary.Resources

  @impl true
  def render(assigns) do
    ~H"""
      <div class="mx-auto max-w-2xl">
        <h2 class="text-xl font-semibold mb-4">Add New Resource</h2>

        <.simple_form
          for={@form}
          id="resource-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.input field={@form[:title]} type="text" label="Title" />
          <.input field={@form[:description]} type="textarea" label="Description" />
          <.input field={@form[:url]} type="url" label="URL" />
          <.input field={@form[:type]} type="select" label="Type" options={["Article", "Video", "Guide", "Practice"]} />
          <.input field={@form[:tags]} type="text" label="Tags (comma or space separated)" value={@tags_text} />

          <:actions>
            <.button phx-disable-with="Saving...">Save Resource</.button>
          </:actions>
        </.simple_form>
      </div>
    """
  end

  @impl true
  def update(%{resource: resource} = assigns, socket) do
    tags_text =
      case Map.get(resource, :tags) do
        nil -> ""
        tags when is_list(tags) -> Enum.join(tags, ", ")
        other -> to_string(other)
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Resources.change_resource(resource))
     end)
     |> assign(:tags_text, tags_text)}
  end

  @impl true
  def handle_event("validate", %{"resource" => params}, socket) do
    tags_text = Map.get(params, "tags", "")
    changeset = Resources.change_resource(socket.assigns.resource, normalize_tags(params))
    {:noreply,
     socket
     |> assign(form: to_form(changeset, action: :validate))
     |> assign(:tags_text, tags_text)}
  end

  @impl true
  def handle_event("save", %{"resource" => resource_params}, socket) do
    save_resource(socket, socket.assigns.action, resource_params)
  end

  defp save_resource(socket, :edit, resource_params) do
    case Resources.update_resource(socket.assigns.resource, normalize_tags(resource_params)) do
      {:ok, _resource} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_resource(socket, :new, resource_params) do
    case Resources.create_resource(normalize_tags(resource_params)) do
      {:ok, _resource} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp normalize_tags(params) do
    tags = Map.get(params, "tags", "")

    tags_list =
      tags
      |> to_string()
      |> String.split([",", " "], trim: true)
      |> Enum.uniq()

    Map.put(params, "tags", tags_list)
  end
end
