defmodule HelloWeb.HelloHTML do
  use HelloWeb, :html  # hello_web.ex, html()

  embed_templates "hello_html/*"
end
