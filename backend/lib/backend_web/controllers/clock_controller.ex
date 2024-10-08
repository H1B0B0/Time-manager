defmodule BackendWeb.ClockController do
  use BackendWeb, :controller

  alias Backend.Time
  alias Backend.Time.Clock

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"userID" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)
    with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"userID" => user_id}) do
    clocks = Time.list_user_clocks(user_id)
    render(conn, :index, clocks: clocks)
  end
end
