defmodule Magento.SearchCriteria.ConditionType do
  @moduledoc """
  Enumeration for condition types

  Reference

  https://developer.adobe.com/commerce/webapi/rest/use-rest/performing-searches/
  """

  def eq, do: "eq"

  def finset, do: "finset"

  def from, do: "from"

  def gt, do: "gt"

  def gteq, do: "gteq"

  # We cannot create a new `in` function, so we alternate `in` name
  # by `in_cond`
  def in_cond, do: "in"

  def like, do: "like"

  def lt, do: "lt"

  def lteq, do: "lteq"

  def moreq, do: "moreq"

  def neq, do: "neq"

  def nfinset, do: "nfinset"

  def nin, do: "nin"

  def nlike, do: "nlike"

  def notnull, do: "notnull"

  def null, do: "null"

  def to, do: "to"

  def enum do
    [
      eq(),
      finset(),
      from(),
      gt(),
      in_cond(),
      like(),
      lt(),
      lteq(),
      moreq(),
      neq(),
      nfinset(),
      nin(),
      nlike(),
      notnull(),
      null(),
      to()
    ]
  end
end

defmodule Magento.SearchCriteria.SortDirection do
  @moduledoc """
  Enumeration for sort directions

  Reference

  https://developer.adobe.com/commerce/webapi/rest/use-rest/performing-searches/#other-search-criteria
  """
  def asc, do: "ASC"

  def desc, do: "DESC"

  def enum do
    [asc(), desc()]
  end
end

defmodule Magento.SearchCriteria do
  @doc """
  Define building search criteria method

  Reference

  https://developer.adobe.com/commerce/webapi/rest/use-rest/performing-searches/
  """

  @filter_schema %{
    condition_type: [type: :string, in: Magento.SearchCriteria.ConditionType.enum()],
    field: [type: :string, required: true],
    value: [type: :string, required: true]
  }

  @filter_group_schema %{
    filters: {:array, @filter_schema}
  }

  @sort_order_schema %{
    direction: [type: :string, in: Magento.SearchCriteria.SortDirection.enum()],
    field: [type: :string, required: true]
  }

  @schema %{
    current_page: :integer,
    page_size: :integer,
    filter_groups: {:array, @filter_group_schema},
    sort_orders: {:array, @sort_order_schema}
  }

  def build_query(params) do
    with {:ok, data} <- Contrak.validate(params, @schema) do
      query = build_query_with_value(data)
      {:ok, query}
    end
  end

  @root_key "searchCriteria"

  defp build_query_with_value(value, parent_key \\ @root_key, query \\ %{})

  defp build_query_with_value([], _parent_key, query), do: query

  defp build_query_with_value(nil, _parent_key, query), do: query

  defp build_query_with_value(values, parent_key, query) when is_list(values) do
    values
    |> Enum.with_index()
    |> Enum.reduce(query, fn {item, index}, acc ->
      item_parent_key = "#{parent_key}[#{index}]"
      build_query_with_value(item, item_parent_key, acc)
    end)
  end

  defp build_query_with_value(value, parent_key, query) when is_map(value) do
    Enum.reduce(value, query, fn {key, value}, acc ->
      item_parent_key = "#{parent_key}[#{key}]"
      build_query_with_value(value, item_parent_key, acc)
    end)
  end

  defp build_query_with_value(value, parent_key, query) do
    Map.put(query, parent_key, value)
  end
end
