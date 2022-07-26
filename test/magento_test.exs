defmodule MagentoTest do
  use ExUnit.Case
  doctest Magento

  test "greets the world" do
    assert Magento.hello() == :world
  end
end
