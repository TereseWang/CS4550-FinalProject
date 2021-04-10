defmodule CatWeb.ForumcommentControllerTest do
  use CatWeb.ConnCase

  alias Cat.Forumcomments
  alias Cat.Forumcomments.Forumcomment

  @create_attrs %{
    body: "some body"
  }
  @update_attrs %{
    body: "some updated body"
  }
  @invalid_attrs %{body: nil}

  def fixture(:forumcomment) do
    {:ok, forumcomment} = Forumcomments.create_forumcomment(@create_attrs)
    forumcomment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all forumcomments", %{conn: conn} do
      conn = get(conn, Routes.forumcomment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create forumcomment" do
    test "renders forumcomment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.forumcomment_path(conn, :create), forumcomment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.forumcomment_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.forumcomment_path(conn, :create), forumcomment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update forumcomment" do
    setup [:create_forumcomment]

    test "renders forumcomment when data is valid", %{conn: conn, forumcomment: %Forumcomment{id: id} = forumcomment} do
      conn = put(conn, Routes.forumcomment_path(conn, :update, forumcomment), forumcomment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.forumcomment_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, forumcomment: forumcomment} do
      conn = put(conn, Routes.forumcomment_path(conn, :update, forumcomment), forumcomment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete forumcomment" do
    setup [:create_forumcomment]

    test "deletes chosen forumcomment", %{conn: conn, forumcomment: forumcomment} do
      conn = delete(conn, Routes.forumcomment_path(conn, :delete, forumcomment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.forumcomment_path(conn, :show, forumcomment))
      end
    end
  end

  defp create_forumcomment(_) do
    forumcomment = fixture(:forumcomment)
    %{forumcomment: forumcomment}
  end
end
