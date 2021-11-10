defmodule BuggeryBullshit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BuggeryBullshit.Repo,
      # Start the Telemetry supervisor
      BuggeryBullshitWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BuggeryBullshit.PubSub},
      # Start the Endpoint (http/https)
      BuggeryBullshitWeb.Endpoint,
      # An HTTP client
      {Finch, name: SCHTTPClient}
      # Start a worker by calling: BuggeryBullshit.Worker.start_link(arg)
      # {BuggeryBullshit.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuggeryBullshit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuggeryBullshitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
