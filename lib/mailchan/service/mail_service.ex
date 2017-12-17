defmodule Mailchan.MailService do
@moduledoc """
  Defines a set of service functions for managing mail
"""

@doc """
  Creates an email address for the given id.
  Also initializes a process to listen for email on this id.
"""
  def initialize_email(email_id) do
    email_address = "#{email_id}@baited.me"
    initialize_email_listener(email_address)
    email_address
  end

  @doc """
    Initializes a process to listen for emails for the given email address.
  """
  defp initialize_email_listener(email_address) do
    # todo
  end

  def receive_message(from, to, data) do
    IO.puts("YOU GOT MAIL from:#{from} to:#{to} data:#{data}")
    :ets.insert(:emails, {Ksuid.generate(), to, from, data})
  end
end