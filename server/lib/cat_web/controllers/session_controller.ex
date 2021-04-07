defmodule CatWeb.SessionController do
  use CatWeb, :controller

  def create(conn, %{"email" => email, "password" => password}) do
    try do
      user = Cat.Users.authenticate(email, password)
      if user do
        sess = %{
          user_id: user.id,
          email: user.email,
          photo_hash: user.photo_hash,
          name: user.name,
          token: Phoenix.Token.sign(conn, "user_id", user.id)
        }
        conn
        |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
        |> send_resp(
        :created,
        Jason.encode!(%{session: sess})
        )
      else
        conn
        |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
        |> send_resp(
        :unauthorized,
        Jason.encode!(%{error: "Password Incorrect"})
        )
      end
    rescue
      _e in Ecto.NoResultsError ->
      conn
      |> put_resp_header(
      "content-type",
      "application/json; charset=UTF-8")
      |> send_resp(
      :unauthorized,
      Jason.encode!(%{error: "User Email Does Not Exist"})
      )
    end
  end
end
