defmodule SkynetWeb.Router do
  use SkynetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SkynetWeb do
    pipe_through :api

    get "/terminators", TerminatorController, :get_terminators
    post "/terminator/build", TerminatorController, :build_terminator
    delete "/terminator/kill/:id", TerminatorController, :kill_terminator
  end
end
