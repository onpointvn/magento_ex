defmodule Magento.Helpers do
  @doc """
  Get configuration from environment
  """
  def get_config do
    options = load_env(:magento, :config)

    %{
      timeout: options[:timeout],
      proxy: options[:proxy],
      partner_url: options[:partner_url],
      api_key: options[:api_key],
      middlewares: options[:middlewares] || []
    }
  end

  @doc """
  Load and parser app config from environment
  """
  def load_env(app, field, default \\ nil) do
    Application.get_env(app, field, default)
    |> load_env_value()
  end

  def load_all_env(app) do
    Application.get_all_env(app)
    |> load_env_value()
  end

  defp load_env_value(nil), do: nil

  defp load_env_value({:system, key}), do: System.get_env(key)

  defp load_env_value(value) when is_list(value), do: Enum.map(value, &load_env_value(&1))

  defp load_env_value(%{} = value) do
    value
    |> Enum.map(&load_env_value(&1))
    |> Enum.into(%{})
  end

  defp load_env_value({k, v}), do: {k, load_env_value(v)}

  defp load_env_value(value), do: value

  @doc """
  Clean nil value from map/list recursively

  Example:

  iex> clean_nil(%{a: 1, b: nil, c: [1, 2, nil]})
    %{a: 1, c: [1, 2]}
  """
  @spec clean_nil(map()) :: map()
  def clean_nil(%{__struct__: mod} = param) when is_atom(mod) do
    param
  end

  def clean_nil(%{} = param) do
    Enum.reduce(param, %{}, fn
      {_key, nil}, acc ->
        acc

      {key, value}, acc ->
        Map.put(acc, key, clean_nil(value))
    end)
  end

  def clean_nil(param) when is_list(param) do
    param
    |> Enum.reduce([], fn item, acc ->
      case item do
        nil ->
          acc

        # handle keyword list
        {_, nil} ->
          acc

        _ ->
          [clean_nil(item) | acc]
      end
    end)
    |> Enum.reverse()
  end

  def clean_nil(param), do: param
end
