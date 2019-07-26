defmodule Bills.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bills.Repo

  def item_factory do
    %Bills.Schema.Item{
      name: sequence(:name, &"A item #{&1}"),
      description: sequence(:description, &"Cute item #{&1}"),
      price: 77.5,
      code: sequence(:code, &"Abc#{&1}")
    }
  end

  def client_factory do
    %Bills.Schema.Client{
      name: sequence(:name, &"A client #{&1}"),
      last_name: sequence(:last_name, &"Last name client #{&1}"),
      identification_number: sequence(:identification_number, &"123-#{&1}")
    }
  end

  def bill_factory do
    %Bills.Schema.Bill{
      total_price: 43.4,
      bill_number: sequence(:bill_number, &"Bill #{&1}"),
      client: build(:client)
    }
  end

  def bill_item_factory do
    %Bills.Schema.BillItem{
      unit_price: 7,
      percent_discount: 10,
      quantity: 10.0,
      total_quantity_price: 63.0,
      bill: build(:bill),
      item: build(:item)
    }
  end
end
