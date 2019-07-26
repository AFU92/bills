defmodule Bills.Crud.ItemCrudTest do
  @moduledoc """
    Item CRUD Test module
  """
  use Bills.DataCase

  alias Bills.Crud.ItemCrud
  alias Bills.Schema.Item

  setup do
    item = insert(:item)

    {:ok, item: item}
  end

  describe "testing get item" do
    test "get item by id successfully", %{item: %{id: item_id}} do
      result = ItemCrud.get_by_id(item_id)
      assert result != nil
      assert %Item{} = result
      assert result.id == item_id
    end

    test "get item by id failed" do
      result = ItemCrud.get_by_id(0)
      assert result == nil
    end

    test "get! item by id successfully",
         %{item: %{id: item_id}} do
      result = ItemCrud.get_by_id!(item_id)
      assert %Item{id: ^item_id} = result
    end

    test "get! item by id failed" do
      assert_raise Ecto.NoResultsError, fn -> ItemCrud.get_by_id!(0) end
    end

    test "get item by code successfully",
         %{item: %{code: code}} do
      assert %{
               name: name,
               description: description,
               price: price,
               code: code
             } = ItemCrud.get_by_code(code)
    end

    test "get item by code failed" do
      result = ItemCrud.get_by_code("code")
      assert result == nil
    end
  end

  describe "testing create item" do
    test "create a item successfully" do
      assert {:ok, item} =
               :item
               |> params_for()
               |> ItemCrud.create_item()
    end

    test "create a item failed" do
      assert {:error, changeset} = ItemCrud.create_item(%{})
      assert length(changeset.errors) != 0
    end

    test "create_item_if_not_exists get existing",
         %{item: item} do
      assert {:ok, item} =
               item
               |> Map.from_struct()
               |> ItemCrud.create_item_if_not_exists()
    end

    test "create_item_if_not_exists create new one" do
      assert {:ok, item} =
               :item
               |> params_for()
               |> ItemCrud.create_item_if_not_exists()
    end
  end

  describe "testing update a item" do
    test "update a item successfully", %{item: item} do
      name = "New item"
      description = "Description new item"
      price = 1500.54
      code = "ZZZ123"

      assert {:ok, result_item} =
               ItemCrud.update_item(item, %{
                 name: name,
                 description: description,
                 price: price,
                 code: code
               })

      assert result_item.id == item.id
      assert result_item.name == name
      assert result_item.description == description
      assert result_item.price == price
      assert result_item.code == code
    end

    test "update a item failed" do
      assert {:error, changeset} = ItemCrud.update_item(%Item{}, %{})
      assert length(changeset.errors) != 0
      assert changeset.valid? == false
    end
  end

  describe "testing delete a item" do
    test "delete a item successfully", %{item: item} do
      assert {:ok, _item} = ItemCrud.delete_item(item)
    end
  end
end
