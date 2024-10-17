defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Backend.Plugs.AuthenticationPlug
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth]

    get "/clocks/:userID", ClockController, :show
    post "/clocks/:userID", ClockController, :create

    get "/user", UserController, :getAllUsers
    get "/users", UserController, :index
    get "/users/:id/", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    delete "/workingtime/:id", WorkingtimeController, :delete
    put "/workingtime/:userID", WorkingtimeController, :update
    post "/workingtime/users", WorkingtimeController, :create
    get "/workingtime/:userID/:id", WorkingtimeController, :show
    get "/workingtime/:userID", WorkingtimeController, :getAll

    get "/roles", RoleController, :index
    get "/roles/:id", RoleController, :show

    post "/auth/user", AuthController, :user

    post "/user/:id/role/:role_id", UserRoleController, :update

    get "/teams", TeamController, :index
    get "/teams/:id", TeamController, :show
    post "/teams", TeamController, :create
    put "/teams/:id", TeamController, :update
    delete "/teams/:id", TeamController, :delete

    post "/user/:id/team/:team_id", UserTeamController, :update
    delete "/user/:id/team", UserTeamController, :delete
  end

  scope "/api", BackendWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login
    post "/users", UserController, :create
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
