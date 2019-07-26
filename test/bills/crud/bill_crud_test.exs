defmodule Bills.Crud.BillCrudTest do
  @moduledoc """
    Bill CRUD Test module
  """
  use Bills.DataCase

  alias Bills.Crud.BillCrud
  alias Bills.Schema.Bill

  setup do
    bill = insert(:bill)
    client = insert(:client)

    {:ok, bill: bill, client: client}
  end

  describe "testing get bill" do
    test "get bill by id successfully", %{bill: %{id: bill_id}} do
      result = BillCrud.get_by_id(bill_id)

      assert %{
               total_price: total_price,
               bill_number: bill_number,
               client: client
             } = result

      assert %Bill{} = result
      assert result.id == bill_id
    end

    test "get bill by id failed" do
      result = BillCrud.get_by_id(0)
      assert result == nil
    end

    test "get! bill by id successfully",
         %{bill: %{id: bill_id}} do
      result = BillCrud.get_by_id!(bill_id)

      assert %{
               total_price: total_price,
               bill_number: bill_number,
               client: client
             } = result

      assert %Bill{} = result
      assert result.id == bill_id
    end

    test "get! bill by id failed" do
      assert_raise Ecto.NoResultsError, fn -> BillCrud.get_by_id!(0) end
    end

    test "get bill by number successfully",
         %{bill: %{bill_number: bill_number}} do
      result = BillCrud.get_by_bill_number(bill_number)

      assert %{
               total_price: total_price,
               bill_number: bill_number,
               client: client
             } = result

      assert %Bill{} = result
      assert result.bill_number == bill_number
    end

    test "get bill by item and bill failed, bill and item not found" do
      result = BillCrud.get_by_bill_number("asda 121")
      assert result == nil
    end
  end

  describe "testing create bill" do
    test "create a bill successfully",
         %{client: %{id: client_id}} do
      assert {:ok, bill} =
               :bill
               |> params_for()
               |> Map.put(:client_id, client_id)
               |> BillCrud.create_bill()
    end

    test "create a bill failed" do
      assert {:error, changeset} = BillCrud.create_bill(%{})
      assert length(changeset.errors) != 0
    end

    test "create_or_update_bill update existing",
         %{bill: bill} do
      assert {:ok, bill} =
               bill
               |> Map.from_struct()
               |> BillCrud.create_or_update_bill()
    end

    test "create_or_update_bill create new one",
         %{client: %{id: client_id}} do
      assert {:ok, bill} =
               :bill
               |> params_for()
               |> Map.put(:client_id, client_id)
               |> BillCrud.create_or_update_bill()
    end
  end

  describe "testing update a bill" do
    test "update a bill successfully",
         %{bill: %{id: bill_id, client_id: client_id, bill_number: bill_number} = bill} do
      total_price = 10.0

      assert {:ok, result_bill} =
               BillCrud.update_bill(bill, %{
                 total_price: total_price,
                 bill_number: bill_number,
                 client_id: client_id
               })

      assert result_bill.id == bill_id
      assert result_bill.total_price == total_price
      assert result_bill.client_id == client_id
    end

    test "update a bill failed" do
      assert {:error, changeset} = BillCrud.update_bill(%Bill{}, %{})
      assert length(changeset.errors) != 0
      assert changeset.valid? == false
    end
  end

  describe "testing delete a bill" do
    test "delete a bill successfully", %{bill: bill} do
      assert {:ok, _bill} = BillCrud.delete_bill(bill)
    end
  end
end
