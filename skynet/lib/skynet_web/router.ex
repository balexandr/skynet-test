defmodule SkynetWeb.Router do
  use SkynetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SkynetWeb do
    pipe_through :api
  end
end
