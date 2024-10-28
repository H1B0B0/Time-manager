defmodule Backend.Auth do
  alias Backend.Repo
  alias Backend.Accounts
  alias Backend.Accounts.User
  use Joken.Config

  @impl Joken.Config
  def token_config do
    Joken.Config.default_claims(default_exp: 43200, iss: "backend", aud: "backend")
  end

  def sign_in(user_id, password) do
    case Accounts.get_user(user_id) do
      nil ->
        {:error, %{reason: :not_found}}

      user ->
        if Pbkdf2.verify_pass(password, user.password) do
          case generate_and_sign(%{"user_id" => user.id}) do
            {:ok, token, _claims} ->
              {:ok, %{token: token}}

            {:error, reason} ->
              {:error, %{reason: reason}}
          end
        else
          {:error, %{reason: :invalid_password}}
        end
    end
  end

  def google_sign_in(email) do
    case Accounts.get_user_by_email(email) do
      nil ->
        {:error, %{reason: :not_found}}

      user ->
        case generate_and_sign(%{"user_id" => user.id}) do
          {:ok, token, _claims} ->
            {:ok, %{token: token}}
          {:error, reason} ->
            {:error, %{reason: reason}}
        end
    end
  end

  def get_user_from_token(token) do
    case verify_and_validate(token) do
      {:ok, claims} ->
        user_id = claims["user_id"]

        case Accounts.get_user(user_id) do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end

      {:error, _reason} ->
        {:error, "Invalid or expired token"}
    end
  end
end
