defmodule WorkbenchWeb.LiveBalanceView do
  use Phoenix.LiveView
  require Ecto.Query

  def render(assigns) do
    WorkbenchWeb.BalanceView.render("index.html", assigns)
  end

  def mount(_, socket) do
    scheduler_state = Workbench.BalanceSnapshots.Scheduler.to_name() |> :sys.get_state()

    assigns = %{
      changeset: Workbench.Balance.changeset(%Workbench.Balance{}, %{}),
      config: scheduler_state.config
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_params(params, _uri, socket) do
    show_config = Map.get(params, "show_config", "false") == "false"

    socket =
      socket
      |> assign(
        balances: balances(),
        show_config: show_config
      )

    {:noreply, socket}
  end

  def handle_event("save", %{"balance" => balance_params}, socket) do
    finish_time = Map.get(balance_params, "finish_time")

    balance_params =
      balance_params
      |> Map.put("start_time", finish_time)
      |> Map.put("finish_time", finish_time)

    changeset = Workbench.Balance.changeset(%Workbench.Balance{}, balance_params)
    {:ok, _} = Workbench.Repo.insert(changeset)
    assigns = %{balances: balances(), changeset: changeset}

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("delete", %{"balance-id" => balance_id}, socket) do
    id = balance_id |> String.to_integer()
    %Workbench.Balance{id: id} |> Workbench.Repo.delete()
    assigns = %{balances: balances()}

    {:noreply, assign(socket, assigns)}
  end

  defp balances do
    Ecto.Query.from(
      b in "balances",
      order_by: [asc: :finish_time],
      select: [
        :id,
        :start_time,
        :finish_time,
        :usd,
        :btc_usd_venue,
        :btc_usd_symbol,
        :btc_usd_price,
        :usd_quote_venue,
        :usd_quote_asset
      ]
    )
    |> Workbench.Repo.all()
  end
end
