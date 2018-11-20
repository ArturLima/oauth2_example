defmodule ContaAzul do
  @moduledoc """
  An OAuth2 strategy for ContaAzul.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: GitHub,
     site: "https://api.contaazul.com",
     authorize_url: "https://api.contaazul.com/auth/authorize",
     token_url: "https://api.contaazul.com/oauth2/token"]
  end

  # Public API

  def client do
    Application.get_env(:oauth2_example, ContaAzul)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
