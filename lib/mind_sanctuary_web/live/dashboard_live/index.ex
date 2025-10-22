defmodule MindSanctuaryWeb.DashboardLive.Index do
  use MindSanctuaryWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    # api_key = System.get_env("API_NINJAS_KEY")
    api_key = System.get_env("fake_key")
    resp = Req.get!(
      "https://api.api-ninjas.com/v1/quotes",
      headers: [{"X-Api-Key", api_key}]
    )
    quote =
      if is_list(resp.body) and resp.body != [] do
        q = Enum.random(resp.body)
        %{text: Map.get(q, "quote"), author: Map.get(q, "author")}
      else
        nil
      end

    {:ok, assign(socket, page_title: "Dashboard", quote: quote)}
  end

end
