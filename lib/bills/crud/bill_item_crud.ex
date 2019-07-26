defmodule Bills.Crud.BillItemCrud do
  @moduledoc """
    BillItem CRUD module
  """
  alias Bills.{Schema.BillItem, Repo}

  def get_by_item_and_bill(item_id, bill_id) do
    Repo.get_by(BillItem, item_id: item_id, bill_id: bill_id)
  end

  def create_bill_item(params) do
    %BillItem{}
    |> BillItem.changeset(params)
    |> Repo.insert()
  end

  def create_or_update_bill_item(params) do
    case get_by_item_and_bill(params.item_id, params.bill_id) do
      nil ->
        create_bill_item(params)

      bill_item ->
        update_bill_item(bill_item, %{quantity: bill_item.quantity + params.quantity})
    end
  end

  def update_bill_item(%BillItem{} = bill_item, params) do
    bill_item
    |> BillItem.changeset(params)
    |> Repo.update()
  end

  def delete_bill_item(%BillItem{} = bill_item) do
    Repo.delete(bill_item)
  end
end
