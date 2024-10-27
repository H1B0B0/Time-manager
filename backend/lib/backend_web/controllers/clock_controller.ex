defmodule BackendWeb.ClockController do
  use BackendWeb, :controller

  alias Backend.Time
  alias Backend.Time.Clock
  alias Backend.Accounts

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"user_id" => user_id}) do
    case Accounts.get_user(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
        |> halt()

      _user ->
        latest_clock = Time.get_latest_clock(user_id)
        clock_params = %{}
          |> Map.put("user_id", user_id)
          |> Map.put("status", latest_clock == nil || !latest_clock.status)
          |> Map.put("time", DateTime.utc_now())

        with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
          |> render(:show, clock: clock)
        end
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    case Accounts.get_user(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
        |> halt()

      _user ->
        clocks = Time.list_user_clocks(user_id)
        render(conn, :index, clocks: clocks)
    end
  end
end
