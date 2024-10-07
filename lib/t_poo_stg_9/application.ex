defmodule TPooStg9.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TPooStg9Web.Telemetry,
      TPooStg9.Repo,
      {DNSCluster, query: Application.get_env(:t_poo_stg_9, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TPooStg9.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TPooStg9.Finch},
      # Start a worker by calling: TPooStg9.Worker.start_link(arg)
      # {TPooStg9.Worker, arg},
      # Start to serve requests, typically the last entry
      TPooStg9Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TPooStg9.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TPooStg9Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
