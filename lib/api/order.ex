defmodule Magento.Order do
  alias Magento.Client

  @doc """
  Lists orders that match specified parameters in search criteria format.

  Reference

  https://magento.redoc.ly/2.4.4-admin/tag/orders#operation/salesOrderRepositoryV1GetListGet
  """
  def list_orders(params, opts \\ []) do
    with {:ok, query} <- Magento.SearchCriteria.build_query(params),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/rest/V1/orders", query: query)
    end
  end
end
