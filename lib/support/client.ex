defmodule Magento.Client do
  @moduledoc """
  Process and sign data before sending to Magento and process response from Magento server
  Proxy could be config
      config :magento, :config,
            proxy: "http://127.0.0.1:9090",
            app_key: "",
            app_secret: "",
            timeout: 10_000,
            response_handler: MyModule,
            middlewares: [] # custom middlewares
  Your custom reponse handler module must implement `handle_response/1`
  """
  alias Magento.Helpers

  @doc """
  Create a new client with given credential.
  Credential can be set using config.
    config :magento, :config
      partner_url: "",
      api_key: ""

  Or could be pass via `opts` argument

  **Options**
  - `partner_url [string]`: The partner URL
  - `access_token [string]`: The access token to authorize a request
  """

  def new(opts \\ []) do
    config = Magento.Helpers.get_config()

    proxy_adapter =
      if config.proxy do
        [proxy: config.proxy]
      else
        nil
      end

    partner_url = opts[:partner_url] || config.partner_url
    access_token = opts[:access_token] || config.access_token

    with {:partner_url, false} <- {:partner_url, is_nil(partner_url)} do
      options =
        [
          adapter: proxy_adapter,
          access_token: access_token
        ]
        |> Helpers.clean_nil()

      middlewares = [
        {Tesla.Middleware.BaseUrl, partner_url},
        {Tesla.Middleware.Opts, options},
        Magento.Middleware.Authentication,
        Tesla.Middleware.JSON
      ]

      # if config setting timeout, otherwise use default settings
      middlewares =
        if config.timeout do
          [{Tesla.Middleware.Timeout, timeout: config.timeout} | middlewares]
        else
          middlewares
        end

      {:ok, Tesla.client(middlewares ++ config.middlewares)}
    else
      {:partner_url, _} ->
        {:error, "Missing partner_url in configuration"}

      error ->
        error
    end
  end

  # @doc """
  # Perform a GET request

  #   get("/users")
  #   get("/users", query: [scope: "admin"])
  #   get(client, "/users")
  #   get(client, "/users", query: [scope: "admin"])
  #   get(client, "/users", body: %{name: "Jon"})
  # """
  # @spec get(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  # def get(client, path, opts \\ []) do
  #   client
  #   |> Tesla.get(path, [{:opts, [api_name: path]} | opts])
  #   |> process()
  # end

  # @doc """
  # Perform a POST request.

  #   post("/users", %{name: "Jon"})
  #   post("/users", %{name: "Jon"}, query: [scope: "admin"])
  #   post(client, "/users", %{name: "Jon"})
  #   post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  # """
  # @spec post(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  # def post(client, path, body, opts \\ []) do
  #   client
  #   |> Tesla.post(path, body, [{:opts, [api_name: path]} | opts])
  #   |> process()
  # end

  # @doc """
  # Perform a POST request.
  #     post("/users", %{name: "Jon"})
  #     post("/users", %{name: "Jon"}, query: [scope: "admin"])
  #     post(client, "/users", %{name: "Jon"})
  #     post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  # """
  # @spec put(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  # def put(client, path, body, opts \\ []) do
  #   client
  #   |> Tesla.put(path, body, [{:opts, [api_name: path]} | opts])
  #   |> process()
  # end

  # @doc """
  # Perform a DELETE request
  #     delete("/users")
  #     delete("/users", query: [scope: "admin"])
  #     delete(client, "/users")
  #     delete(client, "/users", query: [scope: "admin"])
  #     delete(client, "/users", body: %{name: "Jon"})
  # """
  # @spec delete(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  # def delete(client, path, opts \\ []) do
  #   client
  #   |> Tesla.delete(path, [{:opts, [api_name: path]} | opts])
  #   |> process()
  # end

  # defp process(response) do
  #   module =
  #     Application.get_env(:tiktok_shop, :config, [])
  #     |> Keyword.get(:response_handler, __MODULE__)

  #   module.handle_response(response)
  # end

  # @doc """
  # Default response handler for request, user can customize by pass custom module in config
  # """
  # def handle_response(response) do
  #   case response do
  #     {:ok, %{body: body}} ->
  #       case body do
  #         %{"code" => 0} ->
  #           {:ok, body}

  #         _ ->
  #           {:error, body}
  #       end

  #     {_, _result} ->
  #       {:error, %{type: :system_error, response: response}}
  #   end
  # end
end
