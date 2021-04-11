defmodule CatWeb.SessionController do
  use CatWeb, :controller

#referenced from Nat Lecture, Photo_Blog SPA Project session controller
  def create(conn, %{"email" => email, "password" => password}) do
    try do
      user = Cat.Users.authenticate(email, password)
      if user do
        sess = %{
          user_id: user.id,
          email: user.email,
          photo_hash: user.photo_hash,
          name: user.name,
          reason: user.reason,
          token: Phoenix.Token.sign(conn, "user_id", user.id),
          redirect: fetch_reason(user.reason),
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

  def fetch_reason(reason) do
    case reason do
      "Cat Wellness" -> "/wellness"
      "Breeder/Adoption" -> "/selladopt"
      "Lost/Found Cats" -> "/lostfound"
      "Food Choices/Recommendations" -> "/food"
      "Other" -> "/forum"
      _ -> "/"
    end
  end
end
