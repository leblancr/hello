defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  plug HelloWeb.Plugs.Locale, "en" when action in [:index]

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # need in router.ex
    redirect(conn, to: ~p"/redirect_test")
  end

  def redirect_test(conn, _params) do
    conn
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render(:home, layout: false)
  end
end
