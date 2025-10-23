defmodule MindSanctuaryWeb.RoomChannel do
  use MindSanctuaryWeb, :channel

  @impl true
  def join("room:chat", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:chat).
  @impl true
  def handle_in("new_msg", %{"body" => _body} = payload, socket) do
    broadcast(socket, "new_msg", payload)
    {:noreply, socket}
  end

  # intercept ["user_joined"]

  # def handle_out("user_joined", msg, socket) do
  #   if Accounts.ignoring_user?(socket.assigns[:user], msg.user_id) do
  #     {:noreply, socket}
  #   else
  #     push(socket, "user_joined", msg)
  #     {:noreply, socket}
  #   end
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
