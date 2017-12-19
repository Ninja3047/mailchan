defmodule MailchanWeb.MailChannel do
  use Phoenix.Channel
  require Logger

  def join("mail:" <> mail_id, _payload, socket) do
    send(self, {:after_join, mail_id})
    {:ok, socket}
  end

  def handle_info({:after_join, mail_id}, socket) do
    Mailchan.MailSessionManager.monitor(:mail_session_manager, self(), mail_id, socket)
    {:noreply, socket}
  end

  def handle_info("end_session", _params, socket) do
    Logger.debug("Ending session...")
    push socket, "end_session", %{}
    {:stop, :normal, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"Terminating socket... #{inspect reason}"
    :ok
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
