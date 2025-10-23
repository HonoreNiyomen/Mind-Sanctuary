defmodule MindSanctuaryWeb.ResourcesLive.Index do
  use MindSanctuaryWeb, :live_view

  alias MindSanctuary.Mood
  alias MindSanctuary.Mood.Entry

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    entries = Mood.list_entries(user)
    changeset = Mood.change_entry(%Entry{})

    {:ok,
     socket
     |> assign(:entries, entries)
     |> assign(:changeset, changeset)
     |> assign(:current_filter, "all")
     |> assign(:resources, [])
     |> assign(:featured_resources, [])
     |> assign(:show_resource_form, false)
       |> assign(:editing_resource, false)
     |> assign(:page_title, "Resource Hub")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Mood Tracker")
    |> assign(:entry, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Mood Entry")
    |> assign(:entry, %Entry{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = socket.assigns.current_scope.user
    entry = Mood.get_user_entry(user, id)

    socket
    |> assign(:page_title, "Edit Mood Entry")
    |> assign(:entry, entry)
  end

  @impl true
  def handle_event("show_resource_form", _, socket) do
      {:noreply,
       socket
       |> assign(:show_resource_form, true)
       |> assign(:editing_resource, false)
      }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_scope.user
    entry = Mood.get_user_entry(user, id)

    if entry do
      {:ok, _} = Mood.delete_entry(entry)

      {:noreply,
       socket
       |> assign(:entries, Mood.list_entries(user))
       |> put_flash(:info, "Mood entry deleted successfully")}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Entry not found or you don't have permission to delete it")}
    end
  end

  @impl true
  def handle_event("save", %{"entry" => entry_params}, socket) do
    user = socket.assigns.current_scope.user
    save_entry(socket, :new, entry_params, user)
  end

  defp save_entry(socket, :new, entry_params, user) do
    case Mood.create_entry(user, entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> assign(:entries, Mood.list_entries(user))
         |> assign(:changeset, Mood.change_entry(%Entry{}))
         |> put_flash(:info, "Mood entry created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
