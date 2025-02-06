defmodule HelloWeb.CartHTML do
  @moduledoc false
  
  use HelloWeb, :html
  
  alias Hello.ShoppingCart
  
  embed_templates "cart_html/*"
  
  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
