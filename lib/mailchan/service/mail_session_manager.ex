defmodule Mailchan.MailSessionManager do
  use GenServer

  ## state is essentially the ETS table :session.
  ## the state var is always going to be an empty map for this process

  ## Client API
  ## monitors this user's emails session.
  def monitor(server_name, pid, mail_id, socket) do
    GenServer.call(server_name, {:monitor, pid, mail_id, socket})
  end

  def unmonitor(server_name, mail_id, pid) do
    :ets.delete(:sessions, mail_id)
    MailchanWeb.Endpoint.broadcast("mail:#{mail_id}", "end_session", %{})
  end

  ## Server API

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_call({:monitor, pid, mail_id, socket}, _from, state) do
    Process.link(pid)
    :ets.insert(:sessions, {mail_id, socket, pid, :os.system_time(:seconds)})
    {:reply, :ok, state}
  end

  def handle_info({:EXIT, pid, _reason}, state) do
    case :ets.match_object(:sessions, {:_, :_, pid}) do
      [] ->
        {:noreply, state}
      [{mail_id, _, _}] ->
        :ets.delete(:sessions, mail_id)
        {:noreply, state}
    end
  end
end
