defmodule HelloWeb.HelloHTML do
  use HelloWeb, :html  # hello_web.ex, html()

  embed_templates "hello_html/*"  # where .html.heex files are.
  
  attr :messenger_key, :string, required: true
  attr :receiver, :string, required: true
  
  def greet(assigns) do
	  ~H"""
	  <h2>Hello World, from {@messenger_key}!</h2>
	  <h2>Hello World, from {@receiver}!</h2>
	  """
  end
end
