# Magento Extenstion

## Introduction

This extension supports integrate Magento into Elixir projects, including:

- Authetication with Magento admin account.
- Search criteria builder for querying orders, products... via APIs.
- Getting data from Magento APIs using defined functions.

## Process flows

### Order process flow

Follow this tutorial to learn how a Magento order is processed
https://developer.adobe.com/commerce/webapi/rest/tutorials/orders/

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `magento` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:magento, "~> 0.1.0"}
  ]
end
```

## References

https://magento.redoc.ly/2.4.4-admin/

https://developer.adobe.com/commerce/webapi/rest/use-rest/performing-searches/
