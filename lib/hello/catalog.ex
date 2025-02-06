defmodule Hello.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Hello.Repo

  alias Hello.Catalog.Product

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.
  not part of the public context API.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    categories = list_categories_by_id(attrs["category_ids"])

    product
    |> Repo.preload(:categories)
    # Validate product fields
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:categories, categories)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> change_product(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Product |> Repo.get!(id) |> Repo.preload(:categories)
  end

  @doc """
  Increments page view count.

  	Specific to {1, [%Product{views: views}]}:

    The value on the right-hand side is expected to be a 2-element tuple, where:
    The first element is 1, representing the number of rows updated (as returned by Repo.update_all).
    The second element is a list of one or more %Product{} structs.
  	The second element of the tuple is expected to be a list containing a single %Product{} struct.
  	This struct is expected to have a views field.
  	The result of the repo operation returns the number of updated records,
    along with the selected schema values specified by the select option.
    
    Repo.update_all does not return the updated records themselves; instead, it only returns
    a tuple with two elements:
    The number of affected rows.
    A list of the pre-updated structs (before the update), but not the updated fields.
    This is because update_all is a bulk operation that doesn’t fetch the updated records back.

  Pattern matching (=) has lower precedence than the pipe operator,
  so it applies after the piped expression is fully resolved.

  from(p in Product, where: p.id == ^product.id, select: [:views])
    |> Repo.update_all(inc: [views: 1])

  This is executed first, and the result is:
  {1, [%Product{views: updated_views}]}

  Like this:
  query = from(p in Product, where: p.id == ^product.id, select: [:views])
  result = Repo.update_all(query, inc: [views: 1])
  {1, [%Product{views: views}]} = result

  ## Examples

      iex> inc_page_views!(product)
      
  """
  def inc_page_views(%Product{} = product) do
    # 1 means number of rows updated, and a Product struct with views key.
    # DSL
    {1, [%Product{views: views}]} =
      from(p in Product, where: p.id == ^product.id, select: [:views])
      |> Repo.update_all(inc: [views: 1])
      |> IO.inspect(label: "Repo.update_all result")

    put_in(product.views, views)
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(order_by \\ [asc: :description]) do
    Repo.all(from p in Product, order_by: ^order_by)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> change_product(attrs)
    |> Repo.update()
  end

  alias Hello.Catalog.Category

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_categories_by_id(nil), do: []

  def list_categories_by_id(category_ids) do
    Repo.all(from c in Category, where: c.id in ^category_ids)
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end
end
