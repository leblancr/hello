defmodule HelloWeb.Plugs.Locale do
  @moduledoc false

  import Plug.Conn

  @locales ["en", "fr", "de"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    # print all conn items
    conn
    |> Map.from_struct()  # Convert the struct to a map
    |> Enum.each(fn {key, value} ->  # Iterate over the key-value pairs
      IO.puts("item: #{key} => #{inspect(value)}")
    end)

    assign(conn, :locale, loc)
  end

  def call(conn, default) do
    assign(conn, :locale, default)
  end
end
