defmodule Bills.Schema.BillItem do
  @moduledoc """
      BillItem model
  """
  use Ecto.Schema
  alias Bills.Schema.{Bill, Item}

  import Ecto.Changeset

  @primary_key false
  schema "bill_items" do
    field(:unit_price, :float)
    field(:percent_discount, :float)
    field(:quantity, :float)
    field(:total_quantity_price, :float)

    belongs_to(:item, Item, primary_key: true)
    belongs_to(:bill, Bill, primary_key: true)

    timestamps()
  end

  @required_fields [:name, :last_name, :identification_number]
  @optional_fields []

  def changeset(bill_item, params \\ %{}) do
    bill_item
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:identification_number, name: :client_identification_uq)
    |> cast_assoc(:item)
    |> cast_assoc(:bill)
  end
end
