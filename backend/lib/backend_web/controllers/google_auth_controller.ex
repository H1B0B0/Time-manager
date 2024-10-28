defmodule BackendWeb.GoogleAuthController do
  alias Backend.Auth
  alias Backend.Accounts

  use BackendWeb, :controller
  require Logger

  @client_id "832550689961-uk981s634d9r755nuoa8fg3gqpu9gcjb.apps.googleusercontent.com"
  @client_secret "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"
  @redirect_uri "https://backend.traefik.me/api/auth/google"

  plug CORSPlug,
    origin: ["https://frontend.traefik.me"],
    credentials: true,
    headers: ["*"],
    methods: ["GET", "POST", "OPTIONS"],
    expose: ["content-type", "authorization"]

  def index(conn, %{"code" => code} = _params) do
    Logger.info("Received auth code")

    token_url = "https://oauth2.googleapis.com/token"
    body = {
      :form,
      [
        client_id: @client_id,
        client_secret: @client_secret,
        code: code,
        redirect_uri: @redirect_uri,
        grant_type: "authorization_code"
      ]
    }

    case HTTPoison.post(token_url, body, [{"Content-Type", "application/x-www-form-urlencoded"}]) do
      {:ok, %{status_code: 200, body: body}} ->
        token_data = Jason.decode!(body)
        handle_token_success(conn, token_data["access_token"])

      {:ok, %{status_code: status, body: body}} ->
        Logger.error("Token exchange failed with status #{status}: #{body}")
        send_error(conn, :unauthorized, "Failed to exchange authorization code")

      {:error, error} ->
        Logger.error("HTTP request failed: #{inspect(error)}")
        send_error(conn, :internal_server_error, "Internal server error")
    end
  end

  def index(conn, _params) do
    send_error(conn, :bad_request, "Missing authorization code")
  end

  defp handle_token_success(conn, access_token) do
    user_info_url = "https://www.googleapis.com/oauth2/v2/userinfo"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    case HTTPoison.get(user_info_url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        user_data = Jason.decode!(body)
        case Auth.google_sign_in(user_data["email"]) do
          {:ok, %{token: token}} ->
            user = Accounts.get_user_by_email(user_data["email"])

            conn
            |> put_status(:ok)
            |> render(:show, user: user, token: token)

          {:error, reason} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: reason})
            |> halt()
        end

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Failed to fetch user info"})
        |> halt()
    end
  end

  defp send_error(conn, status, message) do
    conn
    |> put_status(status)
    |> render(conn, :show , %{error: message})
  end
end
