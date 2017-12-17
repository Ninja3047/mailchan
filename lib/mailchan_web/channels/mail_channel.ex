defmodule MailchanWeb.MailChannel do
  use Phoenix.Channel

  def join("mail:" <> client_id, _payload, socket) do
    send(self, {:after_join, client_id})
    {:ok, socket}
  end

  def handle_info({:after_join, client_id}, socket) do
    MailchanWeb.MailSessionManager.monitor(:mail_session_manager, self(), client_id, socket)
    {:noreply, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
