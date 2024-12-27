defmodule HelloWeb.Plugs.Locale do
  @moduledoc false

  import Plug.Conn

  @locales ["en", "fr", "de"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    # print all conn items
    conn
    # Convert the struct to a map
    |> Map.from_struct()
    # Iterate over the key-value pairs
    |> Enum.each(fn {key, value} ->
      IO.puts("item: #{key} => #{inspect(value)}")
    end)

    assign(conn, :locale, loc)
  end

  def call(conn, default) do
    assign(conn, :locale, default)
  end
end
