defmodule MailchanWeb.Router do
  use MailchanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MailchanWeb do
    pipe_through :browser # Use the default browser stack

    get "/", MailController, :index
    get "/mail/:email_id", MailController, :mail
  end

  # Other scopes may use custom stacks.
  # scope "/api", MailchanWeb do
  #   pipe_through :api
  # end
end
