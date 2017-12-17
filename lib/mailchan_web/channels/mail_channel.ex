defmodule MailchanWeb.MailChannel do
  use Phoenix.Channel

  def join("mail:" <> mail_id, _payload, socket) do
    send(self, {:after_join, mail_id})
    {:ok, socket}
  end

  def handle_info({:after_join, mail_id}, socket) do
    MailchanWeb.MailSessionManager.monitor(:mail_session_manager, self(), mail_id, socket)
    {:noreply, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
