defmodule WorkbenchWeb.ProductController do
  use WorkbenchWeb, :controller
  alias Tai.Venues.ProductStore

  def show(conn, %{"id" => id}) do
    [venue, symbol] = id |> String.split("-") |> Enum.map(&String.to_atom/1)

    {venue, symbol}
    |> ProductStore.find()
    |> case do
      {:ok, product} ->
        render(conn, "show.html", product: product)

      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(WorkbenchWeb.ErrorView)
        |> render("404.html")
    end
  end
end
