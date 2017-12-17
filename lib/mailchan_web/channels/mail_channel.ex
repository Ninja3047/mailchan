defmodule MailchanWeb.MailChannel do
  use Phoenix.Channel
  def join("mail" <> _client_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

end
