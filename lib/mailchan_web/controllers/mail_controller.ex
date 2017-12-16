defmodule MailchanWeb.MailController do
  use MailchanWeb, :controller

  def index(conn, _params) do
    redirect(conn, [{:to, "/mail/#{Ksuid.generate()}"}])
  end

  def mail(conn, %{"email_id" => email_id}) do
    ## create email address for this id
    text(conn, "ID: #{email_id}")
  end
end
