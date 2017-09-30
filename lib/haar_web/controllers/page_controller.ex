defmodule HaarWeb.PageController do
  use HaarWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
