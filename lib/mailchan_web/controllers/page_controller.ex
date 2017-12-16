defmodule MailchanWeb.PageController do
  use MailchanWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
