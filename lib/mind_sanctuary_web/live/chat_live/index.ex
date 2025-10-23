# lib/mind_sanctuary_web/live/chat_live/index.ex
defmodule MindSanctuaryWeb.ChatLive.Index do
  use MindSanctuaryWeb, :live_view
  alias MindSanctuary.Chats

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id

    {:ok,
     socket
     |> assign(:messages, [])
     |> assign(:message_body, "")
     |> assign(:user_chats, Chats.list_user_chats(user_id))
     |> assign(:channel, nil)
     |> assign(:chat_id, nil)}
  end

  @impl true
  def handle_params(%{"id" => chat_id}, _uri, socket) do
    user_id = socket.assigns.current_scope.user.id

    # Verify access
    if Chats.user_has_access?(chat_id, user_id) do
      {:noreply,
       socket
       |> assign(:live_action, :private)
       |> assign(:chat_id, chat_id)
       |> push_event("join_channel", %{topic: "room:private:#{chat_id}"})}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Access denied")
       |> push_navigate(to: ~p"/chat")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign(:live_action, :index)
     |> assign(:chat_id, nil)
     |> push_event("join_channel", %{topic: "room:public"})}
  end

  @impl true
  def handle_event("send_message", %{"message" => %{"body" => _body}}, socket) do
    # Message will be sent via JavaScript hook
    {:noreply, assign(socket, :message_body, "")}
  end

  def handle_event("new_message", message, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end

  def handle_event("load_messages", %{"messages" => messages}, socket) do
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_event("start_chat", %{"user_id" => other_user_id}, socket) do
    current_user_id = socket.assigns.current_scope.user.id

    case Chats.get_or_create_private_chat(current_user_id, other_user_id) do
      {:ok, chat} ->
        {:noreply, push_navigate(socket, to: ~p"/chat/#{chat.id}")}

      {:error, :cannot_chat_with_self} ->
        {:noreply, put_flash(socket, :error, "You cannot chat with yourself")}
    end
  end
end
