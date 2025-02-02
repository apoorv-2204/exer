defmodule MetaProgWeb.Router do
  use MetaProgWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MetaProgWeb do
    pipe_through :api
  end
end
