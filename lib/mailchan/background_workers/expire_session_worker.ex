defmodule Mailchan.ExpireSessionWorker do
  use GenServer
  require Logger

  @expiration_seconds 15
  @worker_frequency_ms 100

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init(_) do
    schedule_clear()
    {:ok, []}
  end

  def handle_info(:clear, state) do
    ## scan ets table and delete expired entries
    case :ets.select(:sessions,[{{:"$1", :"$2", :"$3", :"$4"},[{:<, :"$4", :os.system_time(:seconds) - @expiration_seconds}],[:"$$"]}]) do
      [] ->
        :ok
      session_list ->
        terminate_sessions(session_list)
    end
    schedule_clear()
    {:noreply, state}
  end

  defp terminate_sessions(session_list) do
    session_list
    |> Enum.each(fn ([mail_id, _, pid, _]) ->
      Logger.error("terminating session for #{mail_id}")
      Mailchan.MailSessionManager.unmonitor(:mail_session_manager, mail_id, pid)
    end)
  end

  defp schedule_clear do
    Process.send_after(self(), :clear, @worker_frequency_ms)
  end
end
