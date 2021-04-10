defmodule Cat.ForumcommentsTest do
  use Cat.DataCase

  alias Cat.Forumcomments

  describe "forumcomment" do
    alias Cat.Forumcomments.Forumcomment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def forumcomment_fixture(attrs \\ %{}) do
      {:ok, forumcomment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forumcomments.create_forumcomment()

      forumcomment
    end

    test "list_forumcomment/0 returns all forumcomment" do
      forumcomment = forumcomment_fixture()
      assert Forumcomments.list_forumcomment() == [forumcomment]
    end

    test "get_forumcomment!/1 returns the forumcomment with given id" do
      forumcomment = forumcomment_fixture()
      assert Forumcomments.get_forumcomment!(forumcomment.id) == forumcomment
    end

    test "create_forumcomment/1 with valid data creates a forumcomment" do
      assert {:ok, %Forumcomment{} = forumcomment} = Forumcomments.create_forumcomment(@valid_attrs)
      assert forumcomment.body == "some body"
    end

    test "create_forumcomment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forumcomments.create_forumcomment(@invalid_attrs)
    end

    test "update_forumcomment/2 with valid data updates the forumcomment" do
      forumcomment = forumcomment_fixture()
      assert {:ok, %Forumcomment{} = forumcomment} = Forumcomments.update_forumcomment(forumcomment, @update_attrs)
      assert forumcomment.body == "some updated body"
    end

    test "update_forumcomment/2 with invalid data returns error changeset" do
      forumcomment = forumcomment_fixture()
      assert {:error, %Ecto.Changeset{}} = Forumcomments.update_forumcomment(forumcomment, @invalid_attrs)
      assert forumcomment == Forumcomments.get_forumcomment!(forumcomment.id)
    end

    test "delete_forumcomment/1 deletes the forumcomment" do
      forumcomment = forumcomment_fixture()
      assert {:ok, %Forumcomment{}} = Forumcomments.delete_forumcomment(forumcomment)
      assert_raise Ecto.NoResultsError, fn -> Forumcomments.get_forumcomment!(forumcomment.id) end
    end

    test "change_forumcomment/1 returns a forumcomment changeset" do
      forumcomment = forumcomment_fixture()
      assert %Ecto.Changeset{} = Forumcomments.change_forumcomment(forumcomment)
    end
  end
end
