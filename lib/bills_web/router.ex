defmodule BillsWeb.Router do
  use BillsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BillsWeb do
    pipe_through :api
  end
end
