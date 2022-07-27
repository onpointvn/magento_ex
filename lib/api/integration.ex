defmodule Magento.Integration do
  alias Magento.Client

  @doc """
  Create access token for admin given the admin credentials

  Parameters

  - `username[string]`: The admin username (required)
  - `password[string]`: The admin password (required)

  Output

  {:ok, jwt_token}

  The JWT token contains these following values:

  - header: {"kid": "1", "alg": "HS256"}
  - payload: {"uid": 1, "utypid": 2, "iat": 1658844905, "exp": 1658848505}
  - signature

  Reference

  https://magento.redoc.ly/2.4.4-admin/tag/integrationadmintoken#operation/twoFactorAuthAdminTokenServiceV1CreateAdminAccessTokenPost
  """
  @create_admin_access_token_schema %{
    username: [type: :string, required: true],
    password: [type: :string, required: true]
  }
  @spec create_admin_access_token(params :: map(), opts :: Keyword.t()) ::
          {:ok, String.t()} | {:error, any()}
  def create_admin_access_token(params, opts \\ []) do
    with {:ok, payload} <- Contrak.validate(params, @create_admin_access_token_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/rest/V1/integration/admin/token", payload)
    end
  end
end
