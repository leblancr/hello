defmodule Hello.ShoppingCart do
  @moduledoc """
  The ShoppingCart context.
  """

  import Ecto.Query, warn: false
  alias Hello.Repo
  alias Hello.Catalog
  alias Hello.ShoppingCart.{Cart, CartItem}
  
  def add_item_to_cart(%Cart{} = cart, product_id) do
	  product = Catalog.get_product!(product_id)
	  
	  %CartItem{quantity: 1, price_when_carted: product.price}
	  |> CartItem.changeset(%{})
	  |> Ecto.Changeset.put_assoc(:cart, cart)
	  |> Ecto.Changeset.put_assoc(:product, product)
	  |> Repo.insert(
	     on_conflict: [inc: [quantity: 1]],
	     conflict_target: [:cart_id, :product_id]
     )
	  # Reload the cart to ensure all items are included and associations are loaded
	  {:ok, reload_cart(cart)}
  end
  
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.
  
  ## Examples
  
      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}
  
  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
	  Cart.changeset(cart, attrs)
  end
  
  @doc """
  Creates a cart.
  
  ## Examples
  
      iex> create_cart(%{field: value})
      {:ok, %Cart{}}
  
      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_cart(user_uuid) do
	  %Cart{user_uuid: user_uuid}
	  |> Cart.changeset(%{})
	  |> Repo.insert()
	  |> case do
		     {:ok, cart} -> {:ok, reload_cart(cart)}
		     {:error, changeset} -> {:error, changeset}
	     end
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)
  
  def get_cart_by_user_uuid(user_uuid) do
	  carts = Repo.one(
	    from(c in Cart,
	      where: c.user_uuid == ^user_uuid,
	      left_join: i in assoc(c, :items),
	      left_join: p in assoc(i, :product),
		    distinct: c.id,  # Ensure only unique carts are returned
	      order_by: [asc: i.inserted_at],
		    preload: [items: {i, product: p}]  # Preload the product for each CartItem
	    )
    )
	  |> Repo.preload(:items)  # Preload the items association
  
    # Print the result to debug
    IO.inspect(carts, label: "Fetched carts")
  end
  
  @doc """
  Returns the list of carts.
  
  ## Examples
  
      iex> list_carts()
      [%Cart{}, ...]
  
  """
  def list_carts do
	  Repo.all(Cart)
  end
  
  defp reload_cart(%Cart{} = cart), do: get_cart_by_user_uuid(cart.user_uuid)
	
	def remove_item_from_cart(%Cart{} = cart, product_id) do
	  {1, _} =
	    Repo.delete_all(
	      from(i in CartItem,
	        where: i.cart_id == ^cart.id,
	        where: i.product_id == ^product_id
	      )
	    )
	    
	  {:ok, reload_cart(cart)}
	end
  
  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end
  
  @doc """
  Updates a cart.
  
  ## Examples
  
      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}
  
      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_cart(%Cart{} = cart, attrs) do
	  changeset =
		  cart
		  |> Cart.changeset(attrs)
		  |> Ecto.Changeset.cast_assoc(:items, with: &CartItem.changeset/2)
	  
	  Ecto.Multi.new()
	  |> Ecto.Multi.update(:cart, changeset)
	  |> Ecto.Multi.delete_all(:discarded_items, fn %{cart: cart} ->
		  from(i in CartItem, where: i.cart_id == ^cart.id and i.quantity == 0)
	  end)
	  |> Repo.transaction()
	  |> case do
	     {:ok, %{cart: cart}} -> {:ok, cart}
	     {:error, :cart, changeset, _changes_so_far} -> {:error, changeset}
     end
  end

  alias Hello.ShoppingCart.CartItem
  
  @doc """
  Gets a single cart_item.
  
  Raises `Ecto.NoResultsError` if the Cart item does not exist.
  
  ## Examples
  
      iex> get_cart_item!(123)
      %CartItem{}
  
      iex> get_cart_item!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  @doc """
  Returns the list of cart_items.

  ## Examples

      iex> list_cart_items()
      [%CartItem{}, ...]

  """
  def list_cart_items do
    Repo.all(CartItem)
  end

  @doc """
  Creates a cart_item.

  ## Examples

      iex> create_cart_item(%{field: value})
      {:ok, %CartItem{}}

      iex> create_cart_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart_item(attrs \\ %{}) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart_item.

  ## Examples

      iex> delete_cart_item(cart_item)
      {:ok, %CartItem{}}

      iex> delete_cart_item(cart_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart_item(%CartItem{} = cart_item) do
    Repo.delete(cart_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart_item changes.

  ## Examples

      iex> change_cart_item(cart_item)
      %Ecto.Changeset{data: %CartItem{}}

  """
  def change_cart_item(%CartItem{} = cart_item, attrs \\ %{}) do
    CartItem.changeset(cart_item, attrs)
  end
  
  def total_item_price(%CartItem{} = item) do
	  Decimal.mult(item.product.price, item.quantity)
  end
  
  def total_cart_price(%Cart{} = cart) do
	  # IO.inspect(cart.items, label: "Cart items for total price")
	  
	  Enum.reduce(cart.items, 0, fn item, acc ->
		  item
		  |> total_item_price()
		  |> Decimal.add(acc)
	  end)
  end
end

