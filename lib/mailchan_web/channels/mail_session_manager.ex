defmodule MailchanWeb.MailSessionManager do
  use GenServer

  ## state is the ETS table :session

  ## Client API
  ## monitors this user's emails session.
  def monitor(server_name, pid, client_id, socket) do
    GenServer.call(server_name, {:monitor, pid, client_id, socket})
  end

  ## Server API

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_call({:monitor, pid, client_id, socket}, _from, state) do
    Process.link(pid)
    :ets.insert(:session, {client_id, socket, pid})
    {:reply, :ok, state}
  end

  def handle_info({:EXIT, pid, _reason}, state) do
    case :ets.match_object(:sessions, {:_, :_, pid}) do
      [] ->
        {:noreply, state}
      [{client_id, :_, :_}] ->
        :ets.delete(:sessions, client_id)
        {:noreply, state}
    end
  end
end