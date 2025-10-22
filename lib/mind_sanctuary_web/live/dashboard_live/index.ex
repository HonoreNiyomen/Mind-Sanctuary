defmodule MindSanctuaryWeb.DashboardLive.Index do
  use MindSanctuaryWeb, :live_view

  alias MindSanctuary.Accounts.Scope

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Dashboard")}
  end

end
