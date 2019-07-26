defmodule Bills.Crud.BillCrud do
  @moduledoc """
    Bill CRUD module
  """
  alias Bills.{Schema.Bill, Repo}

  @spec get_by_id(any) :: any
  def get_by_id(id) do
    Repo.get(Bill, id)
  end

  def get_by_id!(id) do
    Repo.get!(Bill, id)
  end

  def get_by_bill_number(bill_number) do
    Repo.get_by(Bill, bill_number: bill_number)
  end

  def create_bill(params) do
    %Bill{}
    |> Bill.changeset(params)
    |> Repo.insert()
  end

  def create_or_update_build(params) do
    case get_by_bill_number(params.bill_number) do
      nil ->
        create_bill(params)

      bill ->
        update_bill(bill, %{total_price: bill.total_price + params.total_price})
    end
  end

  def update_bill(%Bill{} = bill, params) do
    bill
    |> Bill.changeset(params)
    |> Repo.update()
  end

  def delete_bill(%Bill{} = bill) do
    Repo.delete(bill)
  end
end
