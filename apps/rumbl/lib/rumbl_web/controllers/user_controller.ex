defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts

  def index(plug_conn, _params) do
    render(plug_conn, "index.html", users: Accounts.list_users())
  end

  def show(plug_conn, %{"id" => id}) do
    user = Rumbl.Accounts.get_user(id)
    render(plug_conn, "show.html", user: user)
  end
end
