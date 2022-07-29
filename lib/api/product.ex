defmodule Magento.Product do
  alias Magento.Client

  @doc """
  Lists products that match specified parameters in search criteria format.

  Reference

  https://magento.redoc.ly/2.4.4-admin/tag/products#operation/catalogProductRepositoryV1GetListGet
  """
  @spec list_products(params :: map(), opts :: Keyword.t()) :: {:ok, map()} | {:error, any()}
  def list_products(params, opts \\ []) do
    with {:ok, query} <- Magento.SearchCriteria.build_query(params),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/rest/V1/products", query: query)
    end
  end
end
