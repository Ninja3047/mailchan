defmodule MailchanWeb.MailController do
  use MailchanWeb, :controller

  def index(conn, _params) do
    redirect(conn, [{:to, "/mail/#{Ksuid.generate()}"}])
  end

  def mail(conn, _params) do
    mail_id = Ksuid.generate()
    email   = Mailchan.MailService.initialize_email(mail_id)
    conn    = Plug.Conn.put_resp_cookie(conn, "mail_id", "#{mail_id}", [{:http_only, false}])
    render conn, "index.html", [email: email]
  end
end
