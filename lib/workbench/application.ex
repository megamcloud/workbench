defmodule Workbench.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:workbench)

    {:ok, snapshot_config} = Workbench.BalanceSnapshots.Config.parse()

    children = [
      Workbench.Repo,
      {Workbench.Schoolbus, [topics: [:balance_snapshot]]},
      {Workbench.BalanceSnapshots.Scheduler, [config: snapshot_config]},
      WorkbenchWeb.UserStore,
      WorkbenchWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Workbench.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WorkbenchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
