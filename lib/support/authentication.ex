defmodule Magento.Middleware.Authentication do
  @moduledoc """
  Middleware for integrating access token for each request to Magento
  """
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _) do
    env
    |> prepare_header(env.opts[:access_token])
    |> Tesla.run(next)
  end

  # Requests do not have access token
  defp prepare_header(env, nil), do: env

  defp prepare_header(env, access_token) do
    Tesla.put_headers(env, [{"Authorization", "Bearer #{access_token}"}])
  end
end
