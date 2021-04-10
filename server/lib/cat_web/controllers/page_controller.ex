defmodule CatWeb.PageController do
  use CatWeb, :controller
  alias Cat.Photos

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def photo(conn, %{"hash" => hash}) do
    if hash != "undefined" do
      {:ok, _name, data} = Photos.load_photo(hash)
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, data)
    else
      photos = Application.app_dir(:cat, "priv/photos")
      path = Path.join(photos, "default.jpg")
      {:ok, photo_hash} = Photos.save_photo("default.jpg", path)
      {:ok, _name, data} = Photos.load_photo(photo_hash)
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, data)
    end
  end
end
