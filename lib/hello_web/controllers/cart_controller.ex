defmodule HelloWeb.CartController do
  @moduledoc false
  
  use HelloWeb, :controller
  
  alias Hello.ShoppingCart
  alias Hello.Repo
  import Ecto.Query, only: [where: 2]  # Import `where` from Ecto.Query
  
  def show(conn, _params) do
	  IO.inspect(conn.assigns.cart.items, label: "show Cart items")  # Debugging the items
	  IO.inspect(conn.assigns.cart, label: "Full Cart Data")
	  
	  # Preload both items and their associated products in one step
	  cart = Repo.preload(conn.assigns.cart, items: [:product])  # Preload items and their products together
	  
	  IO.inspect(length(cart.items), label: "Number of Cart Items After Preloading")
	  IO.inspect(cart.items, label: "Preloaded Cart Items")
	  
	  # Generate the changeset for the cart
	  changeset = ShoppingCart.change_cart(cart)
	  
	  # Render the show template with the changeset
	  render(conn, :show, cart: cart, changeset: changeset)
  end
  
  def update(conn, %{"cart" => cart_params}) do
	  case ShoppingCart.update_cart(conn.assigns.cart, cart_params) do
		  {:ok, _cart} ->
			  redirect(conn, to: ~p"/cart")
		  
		  {:error, _changeset} ->
			  conn
			  |> put_flash(:error, "There was an error updating your cart")
			  |> redirect(to: ~p"/cart")
	  end
  end
end

