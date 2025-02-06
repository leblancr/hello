defmodule Hello.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Catalog.Product

  schema "categories" do
    field :title, :string

    many_to_many :products, Product, join_through: "product_categories", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
