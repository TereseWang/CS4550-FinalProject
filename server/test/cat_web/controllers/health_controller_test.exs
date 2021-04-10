defmodule CatWeb.HealthControllerTest do
  use CatWeb.ConnCase

  alias Cat.Healths
  alias Cat.Healths.Health

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:health) do
    {:ok, health} = Healths.create_health(@create_attrs)
    health
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all healths", %{conn: conn} do
      conn = get(conn, Routes.health_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create health" do
    test "renders health when data is valid", %{conn: conn} do
      conn = post(conn, Routes.health_path(conn, :create), health: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.health_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.health_path(conn, :create), health: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update health" do
    setup [:create_health]

    test "renders health when data is valid", %{conn: conn, health: %Health{id: id} = health} do
      conn = put(conn, Routes.health_path(conn, :update, health), health: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.health_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, health: health} do
      conn = put(conn, Routes.health_path(conn, :update, health), health: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete health" do
    setup [:create_health]

    test "deletes chosen health", %{conn: conn, health: health} do
      conn = delete(conn, Routes.health_path(conn, :delete, health))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.health_path(conn, :show, health))
      end
    end
  end

  defp create_health(_) do
    health = fixture(:health)
    %{health: health}
  end
end
