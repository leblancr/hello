defmodule HelloWeb.HelloController do
  use HelloWeb, :controller  # means use HelloWeb controller() function (import)
  # HelloWeb = hello_web.ex

  # used in router.ex
  # _ prefix means unused parameter, _ to avoid warning
  def index(conn, _params) do
	  conn
	  |> put_layout(html: :admin)
	  |> render(:index)
  end

  # like messenger_value = params[messenger]
  # get value associated with key "messenger" from map
  # %{"messenger" => messenger_value} assign to messenger_value variable
  # It captures :messenger from end of url and makes it available in the conn as part of the parameters.
  # this name has to exist in the passed in map
  # pattern matching
	# render :show means hello_html/show.html.heex passing in [messenger: messenger_value]
  # [messenger: messenger_value] Available in show.html.heex as <%= @messenger %>
  def show(conn, %{"messenger_key" => messenger_value} = params) do
	  IO.inspect(url(~p"/users"), label: ~s[url(~p"/users")])
	  IO.inspect(messenger_value, label: "messenger_value")
	  IO.inspect(params, label: "params")
	  # render/3 adds the messenger_key parameter to the conn.assigns map and makes it available in the template.
#	  render(conn, :show, messenger_key: messenger_value, receiver: "the dog")  # keyword list to show.html.heex
	  # same as above manually
	  conn = conn
	  |> assign(:messenger_key, messenger_value)
	  IO.inspect(conn.assigns, label: "conn.assigns")
	  conn = conn
	  |> assign(:receiver, "the dog")
	  |> assign(:items, [%{name: "Item A"}, %{name: "Item B"}, %{name: "Item C"}])
	  IO.inspect(conn.assigns, label: "conn.assigns")
	  conn
	  |> render(:show)
  end
end

