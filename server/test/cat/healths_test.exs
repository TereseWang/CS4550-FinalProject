defmodule Cat.HealthsTest do
  use Cat.DataCase

  alias Cat.Healths

  describe "healths" do
    alias Cat.Healths.Health

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def health_fixture(attrs \\ %{}) do
      {:ok, health} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Healths.create_health()

      health
    end

    test "list_healths/0 returns all healths" do
      health = health_fixture()
      assert Healths.list_healths() == [health]
    end

    test "get_health!/1 returns the health with given id" do
      health = health_fixture()
      assert Healths.get_health!(health.id) == health
    end

    test "create_health/1 with valid data creates a health" do
      assert {:ok, %Health{} = health} = Healths.create_health(@valid_attrs)
    end

    test "create_health/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Healths.create_health(@invalid_attrs)
    end

    test "update_health/2 with valid data updates the health" do
      health = health_fixture()
      assert {:ok, %Health{} = health} = Healths.update_health(health, @update_attrs)
    end

    test "update_health/2 with invalid data returns error changeset" do
      health = health_fixture()
      assert {:error, %Ecto.Changeset{}} = Healths.update_health(health, @invalid_attrs)
      assert health == Healths.get_health!(health.id)
    end

    test "delete_health/1 deletes the health" do
      health = health_fixture()
      assert {:ok, %Health{}} = Healths.delete_health(health)
      assert_raise Ecto.NoResultsError, fn -> Healths.get_health!(health.id) end
    end

    test "change_health/1 returns a health changeset" do
      health = health_fixture()
      assert %Ecto.Changeset{} = Healths.change_health(health)
    end
  end
end
