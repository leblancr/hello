defmodule HelloWeb.HelloHTML do
  # hello_web.ex, html()
  use HelloWeb, :html

  # where .html.heex files are.
  embed_templates "hello_html/*"

  attr :messenger_key, :string, required: true
  attr :receiver, :string, required: true

  def greet(assigns) do
    ~H"""
    <h2>Hello World, from {@messenger_key}!</h2>
    <h2>Hello World, from {@receiver}!</h2>
    """
  end
end
