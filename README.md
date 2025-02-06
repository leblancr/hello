https://hexdocs.pm/phoenix/overview.html#content
To start:
cd hello
mix phx.server

If function missing or other errors:
mix deps.compile or...
mix compile

mix phx.routes
lib/hello_web/router.ex:
# url module action (function name)
get "/", PageController, :home
get "/hello", HelloController, :index
specifies that we need a HelloWeb.HelloController module with an index/2 (conn, params)
http://localhost:4000/hello/beau

lsof -i :4000 - when already in use
app.html.heex is rendered within the root layout
to unsuspend from ^Z fg %1

Dbeaver:
db = hello_dev
Repo.all/1 takes a data source, our User schema in this case, and translates that to an underlying SQL query against our database.

# Module Context schema
mix phx.gen.context Catalog Category categories title:string:unique
mix phx.gen.context Orders Order orders user_uuid:uuid total_price:decimal
mix phx.gen.context Orders LineItem order_line_items price:decimal quantity:integer order_id:references:orders product_id:references:products
mix phx.gen.context ShoppingCart Cart carts user_uuid:uuid:unique
mix phx.gen.context ShoppingCart CartItem cart_items cart_id:references:carts product_id:references:products price_when_carted:decimal quantity:integer
