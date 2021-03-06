defmodule InteractiveTetris.Router do
  use InteractiveTetris.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug InteractiveTetris.CheckUsername, %{ "default" => "/" }
  end

  scope "/", InteractiveTetris do
    pipe_through :browser

    get "/", UserController, :register
    post "/", UserController, :enter
  end

  scope "/", InteractiveTetris do
    pipe_through :browser
    pipe_through :authenticated

    get "/exit", UserController, :exit

    get "/rooms", RoomController, :index
    get "/rooms/new", RoomController, :new

    post "/rooms", RoomController, :create

    delete "/rooms/:id", RoomController, :delete

    get "/rooms/:id/join", RoomController, :join
    get "/rooms/:id/game", GameController, :game
    get "/rooms/:id/summary", GameController, :summary
  end
end
