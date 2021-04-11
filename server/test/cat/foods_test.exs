defmodule Cat.FoodsTest do
  use Cat.DataCase

  alias Cat.Foods

  describe "foods" do
    alias Cat.Foods.Food

    @valid_attrs %{age: 42, body: "some body", brand: "some brand", breed: "some breed", photo_hash: "some photo_hash", price: 42}
    @update_attrs %{age: 43, body: "some updated body", brand: "some updated brand", breed: "some updated breed", photo_hash: "some updated photo_hash", price: 43}
    @invalid_attrs %{age: nil, body: nil, brand: nil, breed: nil, photo_hash: nil, price: nil}

    def food_fixture(attrs \\ %{}) do
      {:ok, food} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Foods.create_food()

      food
    end

    test "list_foods/0 returns all foods" do
      food = food_fixture()
      assert Foods.list_foods() == [food]
    end

    test "get_food!/1 returns the food with given id" do
      food = food_fixture()
      assert Foods.get_food!(food.id) == food
    end

    test "create_food/1 with valid data creates a food" do
      assert {:ok, %Food{} = food} = Foods.create_food(@valid_attrs)
      assert food.age == 42
      assert food.body == "some body"
      assert food.brand == "some brand"
      assert food.breed == "some breed"
      assert food.photo_hash == "some photo_hash"
      assert food.price == 42
    end

    test "create_food/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Foods.create_food(@invalid_attrs)
    end

    test "update_food/2 with valid data updates the food" do
      food = food_fixture()
      assert {:ok, %Food{} = food} = Foods.update_food(food, @update_attrs)
      assert food.age == 43
      assert food.body == "some updated body"
      assert food.brand == "some updated brand"
      assert food.breed == "some updated breed"
      assert food.photo_hash == "some updated photo_hash"
      assert food.price == 43
    end

    test "update_food/2 with invalid data returns error changeset" do
      food = food_fixture()
      assert {:error, %Ecto.Changeset{}} = Foods.update_food(food, @invalid_attrs)
      assert food == Foods.get_food!(food.id)
    end

    test "delete_food/1 deletes the food" do
      food = food_fixture()
      assert {:ok, %Food{}} = Foods.delete_food(food)
      assert_raise Ecto.NoResultsError, fn -> Foods.get_food!(food.id) end
    end

    test "change_food/1 returns a food changeset" do
      food = food_fixture()
      assert %Ecto.Changeset{} = Foods.change_food(food)
    end
  end
end
