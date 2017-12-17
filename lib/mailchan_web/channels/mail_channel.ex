defmodule MailchanWeb.MailChannel do
  use Phoenix.Channel
  def join("mail" <> client_id, _payload, socket) do
    MailchanWeb.MailSessionManager.monitor(:mail_session_manager, self(), client_id, socket)
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_in("new_mail", params, socket) do
    broadcast! socket, "new_mail", %{data: params["body"]}
    {:noreply, socket}
  end
end
