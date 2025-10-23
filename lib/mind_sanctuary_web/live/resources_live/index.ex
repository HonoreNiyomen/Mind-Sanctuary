defmodule MindSanctuaryWeb.ResourcesLive.Index do
  use MindSanctuaryWeb, :live_view
  alias MindSanctuary.Resources

  @impl true
  def mount(_params, _session, socket) do
    resources = Resources.list_resources()
    form = to_form(%{"q" => ""})

    {:ok,
     socket
     |> assign(page_title: "Resource Hub")
     |> assign(form: form, resources: resources, filtered_resources: resources)
     |> assign(show_form: false)}
  end
  
  @impl true
  def handle_event("search", %{"q" => q}, socket) do
    q_down = String.downcase(q || "")

    filtered =
      socket.assigns.resources
      |> Enum.filter(fn r ->
        String.contains?(String.downcase(r.title), q_down) or
          String.contains?(String.downcase(r.description), q_down) or
          Enum.any?(r.tags, fn t -> String.contains?(String.downcase(t), q_down) end)
      end)

    {:noreply, assign(socket, filtered_resources: filtered, form: to_form(%{"q" => q}))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    resource = Resources.get_resource!(id)
    {:ok, _} = Resources.delete_resource(resource)

    resources = Resources.list_resources()

    {:noreply,
     socket
     |> assign(resources: resources, filtered_resources: resources)
     |> put_flash(:info, "Resource deleted successfully")}
  end

  @impl true
  def handle_event("show_form", _params, socket) do
    {:noreply, assign(socket, :show_form, true)}
  end

  @impl true
  def handle_event("hide_form", _params, socket) do
    {:noreply, assign(socket, :show_form, false)}
  end
end
