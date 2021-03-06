defmodule Mailchan.MailService do
  require Logger
@moduledoc """
  Defines a set of service functions for managing mail
"""

@doc """
  Creates an email address for the given id.
"""
  def initialize_email(email_id) do
    "#{email_id}@mailchan.moe"
  end

  def receive_message(from, to, data) do
    Logger.debug("YOU GOT MAIL from:#{from} to:#{to} data:#{data}")
    mail_id = to |> hd |> String.split("@") |> hd
    case :ets.lookup(:sessions, mail_id) do
      [] ->
        Logger.warn("Could not find session for this email #{to}")
        nil
      [{_, socket, _}] ->
        Phoenix.Channel.push socket, "new_mail", %{"data" => data}
    end
  end
end
