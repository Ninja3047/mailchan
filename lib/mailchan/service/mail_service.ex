defmodule Mailchan.MailService do
  require Logger
@moduledoc """
  Defines a set of service functions for managing mail
"""

@doc """
  Creates an email address for the given id.
  Also initializes a process to listen for email on this id.
"""
  def initialize_email(email_id) do
    "#{email_id}@mailchan.moe"
  end

  def receive_message(from, to, data) do
    IO.puts("YOU GOT MAIL from:#{from} to:#{to} data:#{data}")
    client_id = to |> String.split("@") |> hd
    case :ets.lookup(:sessions, client_id) do
      [] ->
        Logger.warn("Could not find session for this email #{to}")
        nil
      [{_, socket, _}] ->
        Phoenix.Channel.push socket, "new_mail", %{"data" => data}
    end
  end
end