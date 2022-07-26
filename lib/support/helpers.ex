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
end
