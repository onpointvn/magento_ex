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

  @doc """
  Update stock items for product.

  Reference
  https://magento.redoc.ly/2.4.4-admin/tag/productsproductSkustockItemsitemId
  """
  @update_stock_item_schema %{
    backorders: [type: :integer, required: true],
    enable_qty_increments: [type: :boolean, required: true],
    extension_attributes: [type: :map],
    is_decimal_divided: [type: :boolean, required: true],
    is_in_stock: [type: :boolean, required: true],
    is_qty_decimal: [type: :boolean, required: true],
    item_id: [type: :integer],
    low_stock_date: [type: :string, required: true],
    manage_stock: [type: :boolean, required: true],
    max_sale_qty: [type: :number, required: true],
    min_qty: [type: :number, required: true],
    min_sale_qty: [type: :number, required: true],
    notify_stock_qty: [type: :number, required: true],
    product_id: [type: :integer],
    qty: [type: :number, required: true],
    qty_increments: [type: :number, required: true],
    show_default_notification_message: [type: :boolean, required: true],
    stock_id: [type: :integer],
    stock_status_changed_auto: [type: :integer, required: true],
    use_config_backorders: [type: :boolean, required: true],
    use_config_enable_qty_inc: [type: :boolean, required: true],
    use_config_manage_stock: [type: :boolean, required: true],
    use_config_max_sale_qty: [type: :boolean, required: true],
    use_config_min_qty: [type: :boolean, required: true],
    use_config_min_sale_qty: [type: :integer, required: true],
    use_config_notify_stock_qty: [type: :boolean, required: true],
    use_config_qty_increments: [type: :boolean, required: true]
  }
  @spec update_stock_item(
          product_sku :: String.t(),
          item_id :: String.t(),
          params :: map(),
          opts :: Keyword.t()
        ) :: {:ok, map()} | {:error, any()}
  def update_stock_item(product_sku, item_id, params, opts \\ []) do
    with {:ok, params} <-
           Contrak.validate(params, @update_stock_item_schema),
         {:ok, client} <- Client.new(opts) do
      Client.put(
        client,
        "/rest/V1/products/#{product_sku}/stockItems/#{item_id}",
        %{"stockItem" => params.stock_item}
      )
    end
  end
end
