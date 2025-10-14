defmodule MindSanctuaryWeb.PageController do
  use MindSanctuaryWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
