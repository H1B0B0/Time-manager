defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Backend.Plugs.AuthenticationPlug
  end

  pipeline :at_least_manager do
    plug Backend.Plugs.AtLeastManager
  end

  pipeline :at_least_general_manager do
    plug Backend.Plugs.AtLeastGeneralManager
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth]

    get "/clocks/:user_id", ClockController, :show
    post "/clocks/:user_id", ClockController, :create

    get "/users", UserController, :index
    get "/users/:user_id/", UserController, :show
    put "/users/:user_id", UserController, :update

    delete "/workingtime/:working_time_id", WorkingtimeController, :delete
    put "/workingtime/:user_id", WorkingtimeController, :update
    post "/workingtime/users", WorkingtimeController, :create
    get "/workingtime/:user_id/:working_time_id", WorkingtimeController, :show
    get "/workingtime/:user_id", WorkingtimeController, :getAll

    get "/roles", RoleController, :index
    get "/roles/:role_id", RoleController, :show

    post "/auth/user", AuthController, :user

    post "/user/:user_id/role/:role_id", UserRoleController, :update

    get "/teams", TeamController, :index
    get "/teams/:team_id", TeamController, :show
    post "/teams", TeamController, :create
    put "/teams/:team_id", TeamController, :update
    delete "/teams/:team_id", TeamController, :delete
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :at_least_manager]

    get "/user", UserController, :getAllUsers
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :at_least_general_manager]

    post "/user/:user_id/team/:team_id", UserTeamController, :update
    delete "/user/:user_id/team", UserTeamController, :delete

    delete "/users/:user_id", UserController, :delete
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
