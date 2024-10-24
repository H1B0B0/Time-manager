defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Backend.Plugs.AuthenticationPlug
  end

  pipeline :is_gm do
    plug Backend.Plugs.IsGMPlug
  end

  pipeline :is_manager_or_gm do
    plug Backend.Plugs.IsManagerOrGMPlug
  end

  pipeline :is_owner_or_gm do
    plug Backend.Plugs.IsOwnerOrGMPlug
  end

  pipeline :is_owner_or_team_owner_or_gm do
    plug Backend.Plugs.IsOwnerOrTeamOwnerOrGMPlug
  end

  pipeline :is_owner do
    plug Backend.Plugs.IsOwnerPlug
  end

  pipeline :is_team_owner_or_gm do
    plug Backend.Plugs.IsTeamOwnerOrGMPlug
  end

  pipeline :create_is_team_owner_or_gm do
    plug Backend.Plugs.Workingtime.CreateIsTeamOwnerOrGMPlug
  end

  pipeline :delete_is_team_owner_or_gm do
    plug Backend.Plugs.Workingtime.DeleteIsTeamOwnerOrGMPlug
  end

  scope "/api", BackendWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login
    post "/users", UserController, :create
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth]

    get "/roles", RoleController, :index
    get "/roles/:role_id", RoleController, :show

    post "/auth/user", AuthController, :user

    get "/user/:user_id/teams", TeamUserController, :show
    get "/team/:team_id/users", TeamUserController, :show
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_gm]

    post "/user/:user_id/role/:role_id", UserRoleController, :update

    get "/teams", TeamController, :index
    post "/teams", TeamController, :create
    put "/teams/:team_id", TeamController, :update
    delete "/teams/:team_id", TeamController, :delete

    post "/user/:user_id/team/:team_id", TeamUserController, :create
    delete "/user/:user_id/team/:team_id", TeamUserController, :delete

    get "/all-users", UserController, :getAllUsers
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_manager_or_gm]

    get "/users", UserController, :index
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_owner_or_gm]

    delete "/users/:user_id", UserController, :delete
    put "/users/:user_id", UserController, :update
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_owner_or_team_owner_or_gm]

    get "/users/:user_id", UserController, :show

    get "/clocks/:user_id", ClockController, :show

    get "/workingtime/:user_id/:working_time_id", WorkingtimeController, :show
    get "/workingtime/:user_id", WorkingtimeController, :getAll
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_owner]

    post "/clocks/:user_id", ClockController, :create
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :is_team_owner_or_gm]

    get "/teams/:team_id", TeamController, :show

    put "/workingtime/:user_id", WorkingtimeController, :update
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :create_is_team_owner_or_gm]

    post "/workingtime/:user_id", WorkingtimeController, :create
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth, :delete_is_team_owner_or_gm]

    delete "/workingtime/:working_time_id", WorkingtimeController, :delete
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
