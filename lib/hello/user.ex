defmodule Hello.User do
  @moduledoc """
  Ecto creates a struct for the User schema with the fields you define
  in the schema block (e.g., :name, :email, :bio, and :number_of_pets).
  """
  # use brings in macros and import brings in functions
  use Ecto.Schema
  # allows to call functions without prefixing them with the module name.
  import Ecto.Changeset

  # schema, field, timestamps macros
  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer

    timestamps(type: :utc_datetime)
  end

  @doc """
  cast and filter out any extraneous parameters.
  validate user input before writing it to the database
    User.changeset(%User{}, %{name: "Joe Example", email: "joe@example.com", bio: "An
  example to all", number_of_pets: 5, random_key: "random value"})
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio])
    |> validate_required([:name, :email, :bio])
    |> validate_length(:bio, min: 2)
  end
end
