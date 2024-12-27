defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelloWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # module plug, goes into init to be default?
    plug HelloWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

    # url, module, function - :label = atom that represents function name
    # controller files in hello_web/controllers/
    # on this route run in this module this function
    # page_controller.ex, home/2
    get "/", PageController, :home
    # Debugging route
    IO.puts("Routing to home/2 action")
    # hello_controller.ex, index/2
    get "/hello", HelloController, :index
    # :messenger_key is the key for the captured value
    get "/hello/:messenger_key", HelloController, :show
    get "/redirect_test", PageController, :redirect_test
    resources "/users", UserController
    resources "/reviews", ReviewController
    resources "/products", ProductController
  end

  scope "/admin", HelloWeb.Admin do
    pipe_through :browser

    # internally generated CRUD urls
    resources "/reviews", ReviewController
    # 	  GET     /admin/reviews                         HelloWeb.Admin.ReviewController :index
    # 	  GET     /admin/reviews/:id/edit                HelloWeb.Admin.ReviewController :edit
    # 	  GET     /admin/reviews/new                     HelloWeb.Admin.ReviewController :new
    # 	  GET     /admin/reviews/:id                     HelloWeb.Admin.ReviewController :show
    # 	  POST    /admin/reviews                         HelloWeb.Admin.ReviewController :create
    # 	  PATCH   /admin/reviews/:id                     HelloWeb.Admin.ReviewController :update
    # 	  PUT     /admin/reviews/:id                     HelloWeb.Admin.ReviewController :update
    # 	  DELETE  /admin/reviews/:id
    resources "/images", ReviewController
    resources "/users", ReviewController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hello, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
