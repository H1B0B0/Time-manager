defmodule BackendWeb.GoogleAuthController do
  alias Backend.Auth
  alias Backend.Accounts

  use BackendWeb, :controller
  require Logger

  @client_id System.get_env("CLIENT_ID_GOOGLE")
  @redirect_uri "https://backend.traefik.me/api/auth/google"

  plug CORSPlug,
    origin: ["https://frontend.traefik.me"],
    credentials: true,
    headers: ["*"],
    methods: ["GET", "POST", "OPTIONS"],
    expose: ["content-type", "authorization"]

  def index(conn, %{"code" => code} = _params) do
    Logger.info("Received auth code")

    token_url = "https://oauth2.googleapis.com/tokeninfo?id_token=#{code}"

    case HTTPoison.get(token_url) do
      {:ok, %{status_code: 200, body: body}} ->
        token_data = Jason.decode!(body)
        handle_token_success(conn, token_data["sub"], token_data["email"])

      {:ok, %{status_code: 401, body: body}} ->
        Logger.error("Unauthorized: #{body}")
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized access: #{body}"})
        |> halt()

      {:ok, %{status_code: status, body: body}} ->
        Logger.error("Token exchange failed with status #{status}: #{body}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Token exchange failed"})
        |> halt()

      {:error, error} ->
        Logger.error("HTTP request failed: #{inspect(error)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error"})
        |> halt()
    end
  end

  defp handle_token_success(conn, sub, email) do
    case Auth.google_sign_in(email) do
      {:ok, %{token: token}} ->
        user = Accounts.get_user_by_email(email)

        conn
        |> put_status(:ok)
        |> render(:show, user: user, token: token)

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
        |> halt()
    end
  end
end
