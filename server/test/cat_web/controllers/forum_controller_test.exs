defmodule CatWeb.ForumControllerTest do
  use CatWeb.ConnCase

  alias Cat.Forums
  alias Cat.Forums.Forum

  @create_attrs %{
    body: "some body",
    photo_hash: "some photo_hash",
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    photo_hash: "some updated photo_hash",
    title: "some updated title"
  }
  @invalid_attrs %{body: nil, photo_hash: nil, title: nil}

  def fixture(:forum) do
    {:ok, forum} = Forums.create_forum(@create_attrs)
    forum
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all forums", %{conn: conn} do
      conn = get(conn, Routes.forum_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create forum" do
    test "renders forum when data is valid", %{conn: conn} do
      conn = post(conn, Routes.forum_path(conn, :create), forum: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.forum_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body",
               "photo_hash" => "some photo_hash",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.forum_path(conn, :create), forum: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update forum" do
    setup [:create_forum]

    test "renders forum when data is valid", %{conn: conn, forum: %Forum{id: id} = forum} do
      conn = put(conn, Routes.forum_path(conn, :update, forum), forum: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.forum_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body",
               "photo_hash" => "some updated photo_hash",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, forum: forum} do
      conn = put(conn, Routes.forum_path(conn, :update, forum), forum: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete forum" do
    setup [:create_forum]

    test "deletes chosen forum", %{conn: conn, forum: forum} do
      conn = delete(conn, Routes.forum_path(conn, :delete, forum))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.forum_path(conn, :show, forum))
      end
    end
  end

  defp create_forum(_) do
    forum = fixture(:forum)
    %{forum: forum}
  end
end
