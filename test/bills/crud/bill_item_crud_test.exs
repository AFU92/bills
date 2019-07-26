defmodule Bills.Crud.BillItemCrudTest do
  @moduledoc """
    BillItem CRUD Test module
  """
  use Bills.DataCase

  alias Bills.Crud.BillItemCrud
  alias Bills.Schema.BillItem

  setup do
    bill_item = insert(:bill_item)
    item = insert(:item)
    bill = insert(:bill)

    {:ok, bill_item: bill_item, item: item, bill: bill}
  end

  describe "testing get bill_item" do
    test "get bill_item by item and bill successfully",
         %{bill_item: %{bill_id: bill_id, item_id: item_id}} do
      result = BillItemCrud.get_by_item_and_bill(item_id, bill_id)

      assert %{
               unit_price: unit_price,
               percent_discount: percent_discount,
               quantity: quantity,
               total_quantity_price: total_quantity_price,
               bill_id: bill_id,
               item_id: item_id
             } = result

      assert %BillItem{} = result
      assert result.bill_id == bill_id
      assert result.item_id == item_id
    end

    test "get bill_item by item and bill failed, bill not found",
         %{bill_item: %{item_id: item_id}} do
      result = BillItemCrud.get_by_item_and_bill(0, item_id)
      assert result == nil
    end

    test "get bill_item by item and bill failed item not found",
         %{bill_item: %{bill_id: bill_id}} do
      result = BillItemCrud.get_by_item_and_bill(0, bill_id)
      assert result == nil
    end

    test "get bill_item by item and bill failed, bill and item not found" do
      result = BillItemCrud.get_by_item_and_bill(0, 0)
      assert result == nil
    end
  end

  describe "testing create bill_item" do
    test "create a bill_item successfully",
         %{bill: %{id: bill_id}, item: %{id: item_id}} do
      assert {:ok, bill_item} =
               :bill_item
               |> params_for()
               |> Map.put(:bill_id, bill_id)
               |> Map.put(:item_id, item_id)
               |> BillItemCrud.create_bill_item()
    end

    test "create a bill_item failed" do
      assert {:error, changeset} = BillItemCrud.create_bill_item(%{})
      assert length(changeset.errors) != 0
    end

    test "create_or_update_bill_item update existing",
         %{bill_item: bill_item} do
      assert {:ok, bill_item} =
               bill_item
               |> Map.from_struct()
               |> BillItemCrud.create_or_update_bill_item()
    end

    test "create_or_update_bill_item create new one",
         %{bill: %{id: bill_id}, item: %{id: item_id}} do
      assert {:ok, bill_item} =
               :bill_item
               |> params_for()
               |> Map.put(:bill_id, bill_id)
               |> Map.put(:item_id, item_id)
               |> BillItemCrud.create_or_update_bill_item()
    end
  end

  describe "testing update a bill_item" do
    test "update a bill_item successfully",
         %{bill_item: %{bill_id: bill_id, item_id: item_id}= bill_item} do
      unit_price = 10.0
      percent_discount = 10.0
      quantity = 10.0
      total_quantity_price = 10.0

      assert {:ok, result_bill_item} =
               BillItemCrud.update_bill_item(bill_item, %{
                 unit_price: unit_price,
                 percent_discount: percent_discount,
                 quantity: quantity,
                 total_quantity_price: total_quantity_price,
                 bill_id: bill_id,
                 item_id: item_id
               })

      assert result_bill_item.unit_price == unit_price
      assert result_bill_item.percent_discount == percent_discount
      assert result_bill_item.quantity == quantity
      assert result_bill_item.total_quantity_price == total_quantity_price
    end

    test "update a bill_item failed" do
      assert {:error, changeset} = BillItemCrud.update_bill_item(%BillItem{}, %{})
      assert length(changeset.errors) != 0
      assert changeset.valid? == false
    end
  end

  describe "testing delete a bill_item" do
    test "delete a bill_item successfully", %{bill_item: bill_item} do
      assert {:ok, _bill_item} = BillItemCrud.delete_bill_item(bill_item)
    end
  end
end
