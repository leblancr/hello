defmodule HelloWeb.HelloController do
  use HelloWeb, :controller  # means use HelloWeb controller() function (import)
  # HelloWeb = hello_web.ex

  # used in router.ex
  # _ prefix means unused parameter, _ to avoid warning
  def index(conn, _params) do
    render(conn, :index)  # render the index template
  end

  # %{"messenger" => messenger} assign to messenger variable
  def show(conn, %{"messenger" => messenger_value}) do
    render(conn, :show, [messenger: messenger_value])  # keyword list
  end
end
