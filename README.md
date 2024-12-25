

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