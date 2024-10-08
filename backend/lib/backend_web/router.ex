defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    get "/clocks/:userID", ClockController, :show
    post "/clocks/:userID", ClockController, :create

    get "/users", UserController, :index
    get "/users/:id/", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    delete "/workingtime/:id", WorkingtimeController, :delete
    put "/workingtime/:userID", WorkingtimeController, :update
    post "/workingtime/users", WorkingtimeController, :create
    get "/workingtime/:userID/:id", WorkingtimeController, :show
    get "/workingtime/:userID", WorkingtimeController, :getAll
  end

  if Application.compile_env(:backend, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
