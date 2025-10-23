defmodule MindSanctuaryWeb.ChatLive.Index do
  use MindSanctuaryWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Chat Room")}
  end

  @impl true
  def handle_event("save", %{"schedule" => _params}, socket) do

        {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, modal_open: false, selected_date: nil)}
  end

end
