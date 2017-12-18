defmodule MailchanWeb.Router do
  use MailchanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  defp put_user_token(conn, params) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "mail socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MailchanWeb do
    pipe_through :browser # Use the default browser stack

    get "/", MailController, :index
    get "/mail/:mail_id", MailController, :mail
  end

  # Other scopes may use custom stacks.
  # scope "/api", MailchanWeb do
  #   pipe_through :api
  # end
end
