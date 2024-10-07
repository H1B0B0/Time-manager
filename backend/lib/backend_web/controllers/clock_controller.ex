defmodule BackendWeb.ClockController do
  use BackendWeb, :controller

  alias Backend.Times
  alias Backend.Times.Clock

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    clocks = Times.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Times.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Times.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Times.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Times.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Times.get_clock!(id)

    with {:ok, %Clock{}} <- Times.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
